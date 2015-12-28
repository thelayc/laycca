#' Clean roster data prior to merging with NWEA data
#' The data set to be cleaned is an export from the "[LAYCCA] students_roster" report
#' @param df dataframe: NWEA data exported from the website
#' @return dataframe
#' @export
#' @examples
#' eto <- load_csv(data_folder = './path/to/data_folder')
#' eto <- clean_roster(df = eto)

clean_roster <- function(df,
                      expected_columns = c("id", "subject_id", "fname", "lname",
                                           "dob", "ell", "ethnicity", "race", 
                                           "start", "end", "days_enrolled"),
                      kept_columns = c("id", "subject_id", "fname", "lname", "dob")
                      ) {
  # CHECK: Check for correct input
  assertthat::assert_that(is.data.frame(df))
  assertthat::validate_that(length(colnames(df)) == length(expected_columns))
  assertthat::validate_that(all.equal(sort(colnames(df)), sort(expected_columns)))

  # Filter out unneccessary columns
  df <- df[, colnames(df) %in% kept_columns]
  
  # Filter out duplicated rows
  df <- df[!duplicated(df), ]

  # Some formatting
  df$dob = lubridate::mdy(df$dob)

  return(df)

}
