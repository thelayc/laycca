id <- c(20001:20010)

subject_id <- c(121:130)

temp <- read.table('./data-raw/yob2014.txt', stringsAsFactors = FALSE, sep = ',')
set.seed(100)
fname <- sample(temp$V1, 10)

lname <- rep('Fake', 10)

dates <-  seq(as.Date("1995-01-01"), as.Date("1995-12-31"), by = "days")
set.sed(100)
dob <- sample(dates, 10)

students_list <- data.frame(id, subject_id, fname, lname, dob, stringsAsFactors = FALSE)

devtools::use_data(students_list, overwrite = TRUE)
