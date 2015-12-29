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



#' get_iqr
#' Takes a subset of a norms_status data as input. Return a data frame with the necesary
#' information to create a boxplot.
#'  
#' @param df dataframe: Subset of norms_status_xxxx data
#'
#' @return dataframe
#' @export
#'
#' @examples
#' library(dplyr)
#' data(norms_status_2015)
#' df <- norms_status_2015 %>%
#'  filter(season == 4) %>%
#'  filter(grade == 11) %>% 
#'  filter(subject == 2)
#' 
#' get_iqr(df)
#' 
get_iqr <- function(df) {
  q25 <- df$rit[df$student_pctile == 25]
  q50 <- df$rit[df$student_pctile == 50]
  q75 <- df$rit[df$student_pctile == 75]
  iqr <- q75 - q25
  my_min <- q25 - 1.5 * iqr
  my_max <- q75 + 1.5 * iqr
  name <- "benchmark"
  
  out <- data.frame(name, my_min, my_max, q25, q50, q75, stringsAsFactors = FALSE)
  
  return(out)
}