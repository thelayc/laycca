norms_2015_raw <- read.csv('./data-raw/norms_status_2015.csv', stringsAsFactors = FALSE)


# data cleaning -----------------------------------------------------------

colnames(norms_2015_raw) <- tolower(colnames(norms_2015_raw))
colnames(norms_2015_raw) <- c("season", "grade", "subject", "rit", "student_pctile", "schl_pctile")

# Save data
devtools::use_data(norms_2015_raw, overwrite = TRUE)
