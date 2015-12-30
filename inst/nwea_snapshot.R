# BEFORE YOU START!
# Manually specify the following contants:
school_start <- '08/01/2014'
school_end <- '12/30/2015'

# Load library ------------------------------------------------------------

library(laycUtils)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

# Load data ---------------------------------------------------------------
list.files('./data-raw/', full.names = TRUE)

nwea <- load_txt("./data-raw/nwea.txt")
roster <- load_txt("./data-raw/roster.txt")
# get norms data
help("norms_status_2015", package = 'laycca')
data("norms_status_2015")
benchmark <- norms_status_2015 %>%
  filter(season == 4) %>%
  filter(grade == 11) %>%
  filter(subject == 2)

# Conduct cleaning and data check ----------------------------------------------
# THIS IS AN ITERATIVE PROCESS MAKE SURE THERE IS NO DATA ERROR BEFORE RUNNING 
# THE NEXT CODE SECTION

# CHECK roster
school_start <- mdy(school_start)
school_end <- mdy(school_end)

roster <- roster %>%
  format_data %>%
  filter(start >= school_start) %>%
  filter(end <= school_end) %>%
  clean_roster(kept_columns = c("id", "subject_id", "fname", "lname", "dob", "ell", "ethnicity", "race"))
   

check_variable(df = roster, var = 'ethnicity', expect = c('latino', 'non-latino'))
check_variable(df = roster, var = 'race', 
               expect = c("caucasian", "african american", "other***", "african descent",
                          "multiracial", "asian", "native american", "arab descent"))
check_variable(df = roster, var = 'ell', expect = c('yes', 'no'))

# CHECK nwea
nwea <- nwea %>%
  format_data %>%
  clean_nwea_tp %>%
  filter(school_year == "2015-2016") %>%
  filter(term == "fall")

nrow(nwea) == length(unique(nwea$subject_id)) # check for duplicate records
# Cleaning due to errors in ETO
# temp <- nwea
# temp$answer_id <- NULL
# nwea <- nwea[!duplicated(temp), ]
# nwea <- nwea[!duplicated(nwea$subject_id), ]

# Merge data --------------------------------------------------------------

df <- right_join(x = roster, y = nwea, by = 'subject_id')
df <- df %>%
  filter(!is.na(id))


# NWEA profile ------------------------------------------------------------

# Generate input for benchmark boxplot
bchmrk <- get_iqr(benchmark)

# Get input for NWEA boxplot
q25 <- quantile(nwea$rit, probs = .25, names = FALSE)
q50 <- quantile(nwea$rit, probs = .5, names = FALSE)
q75 <-quantile(nwea$rit, probs = .75, names = FALSE)
iqr <- q75 - q25
my_min <- q25 - 1.5 * iqr
my_max <- q75 + 1.5 * iqr
name <- paste(unique(nwea$term), unique(nwea$school_year))

nweabxplt <- data.frame(name, my_min, my_max, q25, q50, q75, stringsAsFactors = FALSE)

# Combine datasets
temp <- rbind(bchmrk, nweabxplt)

ggplot(temp, aes(x = name, ymin = my_min, ymax = my_max, 
                     lower = q25, middle = q50, upper = q75, fill = name)) +
  geom_boxplot(stat = 'identity')

# Plot by ethnicity
ggplot(df, aes(x = ethnicity, y = rit, fill = ethnicity)) + geom_boxplot()

# Plot by ell status
ggplot(df, aes(x = ell, y = rit, fill = ell)) + geom_boxplot()

# Plot by ell status
ggplot(df, aes(x = ethnicity, y = rit, fill = ethnicity)) + geom_boxplot() + facet_wrap(~ell)

model <- lm(rit ~ ell + ethnicity + race, data = df)
summary(model)
plot1 <- plot_individual_scores(df)
plot1
