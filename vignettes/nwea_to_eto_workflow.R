## ---- eval = FALSE-------------------------------------------------------
#  
#  # devtools::install_github('thelayc/laycUtils', build_vignettes = TRUE)
#  # devtools::install_github('thelayc/laycca', build_vignettes = TRUE)
#  library(laycUtils)
#  library(laycca)
#  nwea <- load_csv("./path/to/nwea_scores.csv") # Edit the path to your .csv file as needed
#  eto <- load_csv("./path/to/students_list.csv") # Edit the path to your .csv file as needed

## ---- echo = FALSE-------------------------------------------------------
library(laycUtils)
library(laycca)
data(nwea_scores)
nwea <- nwea_scores
dplyr::tbl_df(nwea)
rm(nwea_scores)

## ---- echo = FALSE-------------------------------------------------------
data(students_list)
eto <- students_list
dplyr::tbl_df(eto)
rm(students_list)

## ------------------------------------------------------------------------
nwea <- clean_nwea(nwea)
eto <- clean_roster(eto)

## ------------------------------------------------------------------------
# Create custom id
nwea$custom_id <- create_id(nwea, var = c("StudentLastName", "StudentFirstName"))
eto$custom_id <- create_id(eto, var = c("lname", "fname"))
nwea$custom_id

# Merge
df <- fuzzy_join(x = nwea, y = eto, by = 'custom_id')
head(df)


## ------------------------------------------------------------------------
table(df$match_status)

## ------------------------------------------------------------------------
df <- format_nwea(df)
head(df)

## ---- eval = FALSE-------------------------------------------------------
#  export_nwea(df)

