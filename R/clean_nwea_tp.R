#' Clean NWEA data exported from ETO ("[Admin] raw_touchpoint_report_detailed")
#' @param df dataframe: NWEA data exported from ETO
#' @return dataframe
#' @export
#' @examples
#' nwea <- load_txt("./path/to/nwea_scores.txt")
#' nwea <- clean_nwea_tp(df = nwea)

clean_nwea_tp <- function(df,
                          expected_columns = c("subject_id", "name", "tp_name", 
                                               "date", "question_id", "question",
                                               "question_short", "answer_id",
                                               "answer", "answer_weight", 
                                               "program_name","program_id"),
                          kept_columns = c("subject_id", "name", "date",  
                                           "question_short", "answer_id",
                                           "answer"),
                          expected_terms = c('fall', 'winter', 'spring'),
                          score_min = 100,
                          score_max = 300
                          ) {
  
  # CHECKS:
  assertthat::assert_that(is.data.frame(df))
  assertthat::validate_that(length(colnames(df)) == length(expected_columns))
  assertthat::validate_that(all.equal(sort(colnames(df)), sort(expected_columns)))
  
  # Clean and format df
  df <- laycUtils::format_data(df)
  df <- df[, kept_columns]
  df <- tidyr::spread_(data = df, key_col = "question_short", value_col = "answer")
  df$rit <- as.numeric(df$rit_reading)
  # CHECK: that rit scores are within expected numeric bounds
  assertthat::assert_that(min(df$rit) >= score_min)
  assertthat::assert_that(max(df$rit) >= score_min)
  df["rit_reading"] <- NULL
  # CHECK: that term contains only expected terms
  assertthat::assert_that(all.equal(sort(unique(df$term)), sort(expected_terms)))
  df$term <- factor(df$term, levels = c('fall', 'winter', 'spring'))

  return(df)

}
