rit_to_efl <- read.csv('./data-raw/rit_to_efl.csv', stringsAsFactors = FALSE, na.strings = '')


# data cleaning -----------------------------------------------------------

library(dplyr)

rit_to_efl <- rit_to_efl %>%
  filter(!is.na(rit)) %>%
  select(rit, tabe_reading:nrs_efl) %>%
  arrange(rit, tabe_reading)

# Remove duplicate values of RIT
rit_to_efl <- rit_to_efl[!duplicated(rit_to_efl$rit, fromLast = TRUE), ]

## TO DO:
# Deal with duplicate rit value of 188

devtools::use_data(rit_to_efl, overwrite = TRUE)
