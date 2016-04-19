library(dplyr)

norms_status_2015 <- read.csv('./data-raw/norms_status_2015.csv', stringsAsFactors = FALSE)


# data cleaning -----------------------------------------------------------

colnames(norms_status_2015) <- tolower(colnames(norms_status_2015))
colnames(norms_status_2015) <- c("season", "grade", "subject", "rit", "student_pctile", "schl_pctile")

# Remove duplicate student_pctile values
df <- norms_status_2015 %>%
  group_by(season, grade, subject, student_pctile) %>%
  summarise(rit = max(rit)) %>%
  ungroup()

# Create a function that takes a data frame with incomplete student_pctile values,
interp <- function(df, q = data.frame(student_pctile = c(1:99))) {
  df <- dplyr::left_join(q, df, by = 'student_pctile')
  dfz <- zoo::zoo(df)
  dfz <- as.data.frame(zoo::na.approx(dfz))
  return(dfz)
}

# Run interpolation for each subset
df <- plyr::ddply(df, c('season', 'grade', 'subject'), interp)

norms_status_2015 <- df %>%
  select(season:subject, student_pctile, rit)

norms_status_2015$season <- as.character(norms_status_2015$season)
norms_status_2015$season <- plyr::revalue(norms_status_2015$season, 
                                       c("4" = "fall", "1" = "winter", "2" = "spring", "3" = "summer"))

# Save data
devtools::use_data(norms_status_2015, overwrite = TRUE)
