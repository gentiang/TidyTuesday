# Setting work directory
setwd("C:/Users/gashi/Desktop/TidyTuesday/2022/2022-09-27")

# Loading Libraries
library(tidyverse)
library(ggplot2)
library(janitor)

artists <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-27/artists.csv')

