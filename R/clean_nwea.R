#' Clean NWEA raw data (as exported from the website) so it can be merged with ETO records
#' @param df dataframe: NWEA data exported from the website
#' @return dataframe
#' @export
#' @examples
#' nwea <- load_csv(data_folder = './path/to/data_folder')
#' nwea <- clean_nwea(df = nwea)

clean_nwea <- function(df) {
  # INCLUDE CHECKS
  
  # CHECK: Make column names are as expected
  expected_columns <-
    c(
      "TermName", "DistrictName", "SchoolName", "StudentLastName", "StudentFirstName", "StudentMI", "StudentID", "StudentDateOfBirth", "StudentEthnicGroup", "StudentGender", "Grade", "MeasurementScale", "Discipline", "TestType", "TestName", "TestStartDate", "TestDurationMinutes", "TestRITScore", "TestStandardError", "TestPercentile", "TypicalFallToFallGrowth", "TypicalSpringToSpringGrowth", "TypicalFallToSpringGrowth", "TypicalFallToWinterGrowth", "RITtoReadingScore", "RITtoReadingMin", "RITtoReadingMax", "Goal1Name", "Goal1RitScore", "Goal1StdErr", "Goal1Range", "Goal1Adjective", "Goal2Name", "Goal2RitScore", "Goal2StdErr", "Goal2Range", "Goal2Adjective", "Goal3Name", "Goal3RitScore", "Goal3StdErr", "Goal3Range", "Goal3Adjective", "Goal4Name", "Goal4RitScore", "Goal4StdErr", "Goal4Range", "Goal4Adjective", "Goal5Name", "Goal5RitScore", "Goal5StdErr", "Goal5Range", "Goal5Adjective", "Goal6Name", "Goal6RitScore", "Goal6StdErr", "Goal6Range", "Goal6Adjective", "Goal7Name", "Goal7RitScore", "Goal7StdErr", "Goal7Range", "Goal7Adjective", "Goal8Name", "Goal8RitScore", "Goal8StdErr", "Goal8Range", "Goal8Adjective", "TestStartTime", "PercentCorrect", "ProjectedProficiency", "AccommodationCategory", "Accommodations"
    )
  
  if (!identical(expected_columns, colnames(df))) {
    stop(
      cat(
        "Column headers are not as expected\nExpected column headers are:\n", expected_columns, "\n\n"
      )
    )
  }
  
  # Filter out unneccessary rows
  df <- df[df$MeasurementScale %in% c('Reading'), ]
  
  # Filter out unneccessary columns
  keep <- c("TermName", "StudentLastName", "StudentFirstName", "StudentID", "StudentDateOfBirth", "TestStartDate", "TestRITScore")
  df <- df[, colnames(df) %in% keep]
  
  # Separate testing period and school year
  df <- tidyr::separate(df, col = 'TermName', into = c('term', 'school_year'), sep = ' ')
  
  # Some formatting
  df$term <- factor(df$term, levels = c('Fall', 'Winter', 'Spring'))
  df$TestStartDate = lubridate::mdy(df$TestStartDate)
  
  return(df)
  
}
