library(ggplot2)
library(dplyr)
library(GGally)
library(tidyr)
library(lubridate)

# Load data ---------------------------------------------------------------

nwea <- load_nwea('../temp_data/nwea')


# Clean data --------------------------------------------------------------

nwea %>%
  filter(MeasurementScale %in% c('Reading')) %>%
  select(TermName, TestStartDate, StudentLastName, StudentFirstName, StudentID, StudentDateOfBirth, StudentEthnicGroup, StudentGender, Grade, TestDurationMinutes, TestRITScore, TestStandardError, TestPercentile, RITtoReadingScore) %>%
  separate(col = TermName, into = c('term', 'school_year'), sep = " ") %>%
  mutate(test_date = mdy(TestStartDate)) ->
  rit

rit$term <- factor(rit$term, levels = c('Fall', 'Winter', 'Spring'))
levels(rit$term)


# Baseline analysis -------------------------------------------------------
baseline <-
  rit %>% filter(school_year %in% c('2014-2015'),
                 term %in% c('Fall'))

p <- ggplot(data = baseline,
            aes(fill = StudentEthnicGroup, x = TestRITScore))
#p <- p + coord_flip()
#p <- p + geom_boxplot(varwidth = TRUE)
p <- p + geom_density()
p

df2 <-
  df %>% select(StudentEthnicGroup, StudentGender, Grade, TestRITScore)
ggpairs(df2)


# Growth analysis ---------------------------------------------------------

growth <-
  rit %>% filter(school_year %in% c('2014-2015'))

p <- ggplot(data = growth,
            aes(x = term, fill = term, y = TestRITScore))
p <- p + coord_flip()
p <- p + geom_boxplot()
p


# Growth analysis bis -----------------------------------------------------

rit <- id_prepost(rit)
rit <- filter(rit, !is.na(prepost))







