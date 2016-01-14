rit_to_efl <- read.csv('./data-raw/rit_to_efl.csv', stringsAsFactors = FALSE, na.strings = '')


# data cleaning -----------------------------------------------------------

library(dplyr)

rit_to_efl <- rit_to_efl %>%
  filter(!is.na(rit)) %>%
  select(rit, tabe_reading:nrs_efl) %>%
  arrange(rit, tabe_reading)

# Remove duplicate values of RIT
rit_to_efl <- rit_to_efl[!duplicated(rit_to_efl$rit, fromLast = TRUE), ]

# Add rows for low values of RIT that are not in the original dataset
rit <- 150:175
tabe_reading <- rep(NA, 26)
lexile <- rep(NA, 26)
nrs_efl <- rep(1, 26)
temp <- data.frame(rit, tabe_reading, lexile, nrs_efl)
rit_to_efl <- rbind(temp, rit_to_efl)


## TO DO:
# Deal with duplicate rit value of 188

devtools::use_data(rit_to_efl, overwrite = TRUE)
