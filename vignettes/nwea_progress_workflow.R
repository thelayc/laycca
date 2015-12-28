## ---- eval = FALSE-------------------------------------------------------
#  
#  # devtools::install_github('thelayc/laycUtils', build_vignettes = TRUE)
#  # devtools::install_github('thelayc/laycca', build_vignettes = TRUE)
#  library(laycUtils)
#  library(laycca)
#  nwea <- load_txt("./path/to/nwea_scores.txt") # Edit the path to your .csv file as needed
#  students <- load_txt("./path/to/students_list.txt") # Edit the path to your .csv file as needed

## ---- echo = FALSE-------------------------------------------------------
library(laycUtils)
library(laycca)
data(nwea_eto)
nwea <- nwea_eto
dplyr::tbl_df(nwea)
rm(nwea_eto)

## ---- echo = FALSE-------------------------------------------------------
data(students_list)
students <- students_list
dplyr::tbl_df(students)
rm(students_list)

