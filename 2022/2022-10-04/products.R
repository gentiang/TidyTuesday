# Setting work directory
setwd("C:/Users/gashi/Desktop/TidyTuesday/2022/2022-10-04")

# Loading Libraries
library(tidytuesdayR)
library(tidyverse)
library(ggplot2)
library(janitor)
library(scales)
library(showtext)
library(ggtext)
library(glue)

#Loading fonts
font_add_google(name = "Montserrat", family = "Montserrat")
font <- "Montserrat"

# turn on showtext --------------------------------------------------------
showtext_auto()

# Loading datasets
product_hunt <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-04/product_hunt.csv')

# Data Processing
product_cat <- product_hunt %>% 
  mutate(category_tags = str_remove_all(category_tags, "\\[|\\]|\\'")) %>% #regular expression to remove the brackets and apostrophes
  separate_rows(category_tags, sep = ", ") #separates string into multiple rows by separator
