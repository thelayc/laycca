nwea_scores <- read.csv('./data-raw/nwea_scores.csv', stringsAsFactors = FALSE)

devtools::use_data(nwea_scores, overwrite = TRUE)
