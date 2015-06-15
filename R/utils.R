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

#' id_prepost()
#'
#' This is a helper function that identifies 'pre' and 'post' test based on the date the test was taken.
#' @param df dataframe: a dataframe containing longitudinal data.
#' @return dataframe
#' @export
#' @examples
#'

id_prepost <- function(df, group_var = c('StudentFirstName', 'StudentLastName'),
                       date_var = 'test_date') {

  df <- dplyr::group_by_(df, .dots = group_var)
  df <- dplyr::mutate_(df,
                       first = lazyeval::interp(~min(v), v = as.name(date_var)),
                       last = lazyeval::interp(~max(v), v = as.name(date_var)))
  df <- dplyr::ungroup(df)
  df <- as.data.frame(df)

  # Assign pre / post values to first / last date taken

  df$prepost[df[, date_var] == df$first & df$first != df$last] <- 'pre'
  df$prepost[df[, date_var] == df$last & df$first != df$last] <- 'post'
  df$prepost <- factor(df$prepost, levels = c('pre', 'post'))
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
#' @examples


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
