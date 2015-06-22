library(ggplot2)
library(dplyr)
library(GGally)
library(tidyr)
library(lubridate)
library(laycUtils)

# Load data ---------------------------------------------------------------

list.files('./data-raw', full.names = TRUE, recursive = TRUE)
nwea <- load_csv("./data-raw/raw_nwea/NWEA Tests Fall SY 2012-13.csv")
eto <- load_csv("./data-raw/students_list.csv")


# Clean data --------------------------------------------------------------

nwea <- clean_nwea(nwea)



# Merge data --------------------------------------------------------------

# Create custom id
nwea$my_id <- create_id(nwea, var = c("StudentLastName", "StudentFirstName"))
eto$my_id <- create_id(eto, var = c("lname", "fname"))

# Merge
df <- fuzzy_join(x = nwea, y = eto, by = 'my_id')

# Format data for upload-----------------------------------------------------

df <- format_nwea(df)

# Save as a .csv

export_nwea(df)





