# 3.1 Writing function/program to process data from an external file 
#(loading in the data from a csv

meteorites <- read.csv("..\\week_2_ weekend_homework/data/meteorite_landings.csv")


# 3.3 Writing function/program to clean data 

library(tidyverse)
library(janitor)

meteorites <- clean_names(meteorites)

# exploring data
names(meteorites)
glimpse(meteorites)
head(meteorites)
view(meteorites)

# 3.4 Writing function/program to wrangle data 


meteorites <- meteorites %>%
  #splitting a column into two
  separate(geo_location, c("latitude", "longitude"), sep = ", ") %>% 
  # remove brackets
  mutate(latitude = as.numeric(str_extract(latitude, "[0-9]+\\.[0-9]+")),
         longitude = as.numeric(str_extract(longitude, "[0-9]+\\.[0-9]+")) 
  ) 


# check for missing values


missing_val <- meteorites %>% 
  filter(is.na(longitude),
         is.na(latitude))

missing_val

# check how many missing values there are

meteorites %>% 
  summarise(count_longitude = sum(is.na(longitude)),
            count_latitude  = sum(is.na(latitude))
  )

# replace missing values with '0'

meteorites <- meteorites %>% 
  mutate(latitude = coalesce(latitude, 0),
         longitude = coalesce(longitude, 0))

# check if there are any missing values left
meteorites %>% 
  filter(is.na(latitude), 
         is.na(longitude))

# remove meteorites less than 1000g in weight from the data

meteorites_tidy <- meteorites %>% 
  mutate(lightweight = if_else(mass_g < 1000, TRUE,
                               FALSE)) %>% 
  subset(lightweight == FALSE) %>% 
  arrange(year) # arrange by year

# print the meteorites_tidy
meteorites_tidy

# save the meteorites_tidy into a clean_data folder
saveRDS(meteorites_tidy, file = "..\\week_2_ weekend_homework/clean_data/meteorites_tidy.RDS")
