#' load_nwea()
#'
#' Helper function to load and combine various NWEA scores export files
#' @param data_folder character: path to folder containing NWEA scores .csv files.
#' @return dataframe
#' @export
#' @examples
#' nwea <- load_nwea(data_folder = './path/to/data_folder')

load_nwea <- function(data_folder) {
  # Retrieve names of all .csv files in the data_folder
  files <- list.files(data_folder,
                      full.names = TRUE,
                      pattern = 'csv$')
  # CHECK: Make sure data_folder is not empty
  if (length(files) == 0) {
    stop(
      cat(
        "There is no .csv files in", data_folder, "\n\nYour current working directory is:\n", getwd(), "\n\n")
      )
  }

  # Load all .csv files in memory
  df_list <- lapply(files, read.csv, stringsAsFactors = FALSE, na.strings = "")

  # Combine them into one data frame
  df <- plyr::rbind.fill(df_list)

  # Return dataframe
  return(df)
}


#' compute_change()
#'
#' This is a helper function that computes change in score between pre and post test. The data must be pre-processed by the followng function: id_prepost()
#' @param df dataframe: a dataframe returned by id_prepost()
#' @param col character vector: name of columns to keep to compute change in scores.
#' @return dataframe
#' @export
#' @import dplyr


compute_change <- function(df, col = c('subject_id', 'prepost', 'score')) {

  ## Compute change: post-score minus pre-score
  # Select only relevant columns
  out <- df[ , col]
  # Remove duplicates
  out <- unique(out)
  # Remove NAs
  # out <- out[!is.na(out$prepost), ]
  # Sort rows
  out <- dplyr::arrange_(out, ~subject_id, ~desc(prepost)) # Add unit test to check that the ordering is correct
  # Group by subject_id in order to compute change for each participant
  out <- dplyr::group_by_(out, ~subject_id)
  # Remove participants without matching pre / post
  out <-  dplyr::mutate_(out, n = ~length(subject_id))
  out <- dplyr::filter_(out, ~n > 1)
  # Compute change
  out <-  dplyr::mutate_(out, change = ~diff(score))
  # Keep only relevant information
  out <-  dplyr::ungroup(out)
  out <-  dplyr::select_(out, ~subject_id, ~change)
  out <-  dplyr::distinct_(out)

  # Add classification variable: positive, no change, negative
  out$change_ord[out$change > 0] <- 'positive'
  out$change_ord[out$change == 0] <- 'no change'
  out$change_ord[out$change < 0] <- 'negative'

  # Merge out with original dataset
  df <- left_join(df, out, by = 'subject_id')

  # Return dataframe
  return(df)
}


#' recode_change()
#'
#' This is a helper function that recode a numeric vector into 3 categories: positive, no change, negative
#' @param numeric vector
#' @return factor vector
#' @export

recode_change <- function(vector) {
  out <- vector
  out[vector > 0] <- 'positive'
  out[vector == 0] <- 'no change'
  out[vector < 0] <- 'negative'
  out <- factor(out, levels = c('positive', 'no change', 'negative'))
  
  return(out)
}

# #' tidy_tp()
# #'
# #' This is a helper function that does some tidying of data exported from ETO through the "[Admin] raw_touchpoint_report_detailed" 
# #' @param df dataframe: a dataframe
# #' @param col character vector: name of columns to keep to compute change in scores.
# #' @return dataframe
# #' @export
# #' @import dplyr
# 
# tidy_tp <- function(df, tp_name = NULL, program_name = NULL) {
#   
#   # CHECK:
#   assertive::is_data.frame(df) 
#   assertive::is_character(tp_name) | assertive::is_null(tp_name)
#   assertive::is_character(program_name) | assertive::is_null(program_name)
#   
#   # Remove unused rows
#   df <- df[df$tp_name == tp_name, ]
#   df <- df[df$program_name == program_name, ]
#   # Remove unused columns
#   select(-tp_name, -question, -question_id, -(answer_weight:program_id)) %>%
#   tidyr::spread(question_short, answer) ->
#   nwea
# 
# nwea$rit_reading <- as.numeric(nwea$rit_reading)

#' rit_to_grade()
#'
#' This is a helper function that converts RIT reading scores into grade equivalent. The conversion is based on the NWEA Normative Data Reference  \url{https://www.nwea.org/resources/2015-normative-data/}
#' @param rit dataframe: a dataframe containing RIT reading scores to be converted
#' @param ref_table dataframe: reference table to be used for the conversion of RIT scores to grades
#' @param col character vector: name of columns to keep to compute change in scores.
#' @return dataframe
#' @export

rit_to_grade <- function(rit, ref_table) {

rit$grade[rit$rit_reading > ref_table$rit[10]] <- ref_table$grade[11]
rit$grade[rit$rit_reading <= ref_table$rit[10]] <- ref_table$grade[10]
rit$grade[rit$rit_reading <= ref_table$rit[9]] <- ref_table$grade[9]
rit$grade[rit$rit_reading <= ref_table$rit[8]] <- ref_table$grade[8]
rit$grade[rit$rit_reading <= ref_table$rit[7]] <- ref_table$grade[7]
rit$grade[rit$rit_reading <= ref_table$rit[6]] <- ref_table$grade[6]
rit$grade[rit$rit_reading <= ref_table$rit[5]] <- ref_table$grade[5]
rit$grade[rit$rit_reading <= ref_table$rit[4]] <- ref_table$grade[4]
rit$grade[rit$rit_reading <= ref_table$rit[3]] <- ref_table$grade[3]
rit$grade[rit$rit_reading <= ref_table$rit[2]] <- ref_table$grade[2]
rit$grade[rit$rit_reading <= ref_table$rit[1]] <- ref_table$grade[1]

rit$grade <- as.numeric(rit$grade)

return(rit)
}