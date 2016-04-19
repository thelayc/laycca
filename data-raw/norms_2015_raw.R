norms_2015_raw <- read.csv('./data-raw/norms_status_2015.csv', stringsAsFactors = FALSE)


# data cleaning -----------------------------------------------------------

colnames(norms_2015_raw) <- tolower(colnames(norms_2015_raw))
colnames(norms_2015_raw) <- c("season", "grade", "subject", "rit", "student_pctile", "schl_pctile")

norms_2015_raw$season <- as.character(norms_2015_raw$season)
norms_2015_raw$season <- plyr::revalue(norms_2015_raw$season, 
                                       c("4" = "fall", "1" = "winter", "2" = "spring", "3" = "summer"))

# Save data
devtools::use_data(norms_2015_raw, overwrite = TRUE)
