rit_to_efl <- read.csv('./data-raw/rit_to_efl.csv', stringsAsFactors = FALSE, na.strings = '')


# data cleaning -----------------------------------------------------------

library(dplyr)

rit_to_efl <- rit_to_efl %>%
  filter(!is.na(rit)) %>%
  select(rit, tabe_reading:nrs_efl)


## TO DO:
# Deal with duplicate rit value of 188

devtools::use_data(rit_to_efl, overwrite = TRUE)
