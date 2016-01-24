students_list <- read.csv('./data-raw/students_list.csv', stringsAsFactors = FALSE)

devtools::use_data(students_list, overwrite = TRUE)
