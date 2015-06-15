#' clean_nwea()
#'
#' Helper function to clean the data frame containing NWEA scores
#' @param nwea dataframe: data frame containing NWEA scores
#' @return dataframe
#' @export
#' @examples
#' nwea <- load_nwea(data_folder = './path/to/data_folder')
#' nwea <- clean_nwea(nwea)

clean_nwea <- function(nwea) {

  # CHECK: Make column names are as expected
  expected_columns <-
    c(
      "TermName", "DistrictName", "SchoolName", "StudentLastName", "StudentFirstName", "StudentMI", "StudentID", "StudentDateOfBirth", "StudentEthnicGroup", "StudentGender", "Grade", "MeasurementScale", "Discipline", "TestType", "TestName", "TestStartDate", "TestDurationMinutes", "TestRITScore", "TestStandardError", "TestPercentile", "TypicalFallToFallGrowth", "TypicalSpringToSpringGrowth", "TypicalFallToSpringGrowth", "TypicalFallToWinterGrowth", "RITtoReadingScore", "RITtoReadingMin", "RITtoReadingMax", "Goal1Name", "Goal1RitScore", "Goal1StdErr", "Goal1Range", "Goal1Adjective", "Goal2Name", "Goal2RitScore", "Goal2StdErr", "Goal2Range", "Goal2Adjective", "Goal3Name", "Goal3RitScore", "Goal3StdErr", "Goal3Range", "Goal3Adjective", "Goal4Name", "Goal4RitScore", "Goal4StdErr", "Goal4Range", "Goal4Adjective", "Goal5Name", "Goal5RitScore", "Goal5StdErr", "Goal5Range", "Goal5Adjective", "Goal6Name", "Goal6RitScore", "Goal6StdErr", "Goal6Range", "Goal6Adjective", "Goal7Name", "Goal7RitScore", "Goal7StdErr", "Goal7Range", "Goal7Adjective", "Goal8Name", "Goal8RitScore", "Goal8StdErr", "Goal8Range", "Goal8Adjective", "TestStartTime", "PercentCorrect", "ProjectedProficiency", "AccommodationCategory", "Accommodations"
    )

  if (!identical(expected_columns, colnames(nwea))) {
    stop(
      cat(
        "Column headers are not as expected\nExpected column headers are:\n", expected_columns, "\n\n"
      )
    )
  }

# Filter out unneccessary information
}
