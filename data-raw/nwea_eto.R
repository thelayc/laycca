nwea_eto <- read.csv('./data-raw/nwea_eto.csv', stringsAsFactors = FALSE)

devtools::use_data(nwea_eto, overwrite = TRUE)
