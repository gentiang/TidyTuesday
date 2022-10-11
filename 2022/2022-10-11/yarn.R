# Setting work directory
setwd("C:/Users/gashi/Desktop/TidyTuesday/2022/2022-10-11")

# Loading Libraries
library(tidytuesdayR)
library(tidyverse)
library(ggplot2)
library(janitor)
library(scales)
library(showtext)
library(ggtext)
library(glue)
library(lubridate)

#Loading fonts
font_add_google(name = "Montserrat", family = "Montserrat")
font <- "Montserrat"

## turn on showtext
showtext_auto()

# Loading datasets
yarn <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-11/yarn.csv')

summary(yarn)

yarn %>% 
  tabyl(yarn_weight_name) %>% 
  arrange(desc(n))

yarn %>% 
  tabyl(texture) %>% 
  arrange(desc(n))