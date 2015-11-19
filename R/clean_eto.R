#' Clean ETO data prior to merging with NWEA data
#' The data set to be cleaned is an export from the "[LAYCCA] students_roster" report
#' @param df dataframe: NWEA data exported from the website
#' @return dataframe
#' @export
#' @examples
#' eto <- load_csv(data_folder = './path/to/data_folder')
#' eto <- clean_eto(df = eto)

clean_eto <- function(df) {
  # CHECK: Chekc for correct input
  assertthat::assert_that(is.data.frame(df))
  # CHECK: Make column names are as expected
  expected_columns <-
    c(
      "id", "subject_id", "fname", "lname", "dob", "ell", "ethnicity", "race", "start", "end", "days_enrolled"
    )

  if (!identical(expected_columns, colnames(df))) {
    warning(
      cat(
        "Column headers are not as expected\nExpected column headers are:\n", expected_columns, "\n\n"
      )
    )
  }

  # Filter out unneccessary columns
  keep <- c("id", "subject_id", "fname", "lname", "dob")
  df <- df[, colnames(df) %in% keep]
  
  # Filter out duplicated rows
  df <- df[!duplicated(df), ]

  # Some formatting
  df$dob = lubridate::mdy(df$dob)

  return(df)

}
