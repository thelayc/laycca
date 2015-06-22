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







