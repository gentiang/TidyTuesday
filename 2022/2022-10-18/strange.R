# Setting work directory
setwd("C:/Users/gashi/Desktop/TidyTuesday/2022/2022-10-11")

# Loading Libraries
library(tidyverse)
library(ggplot2)
library(janitor)
library(scales)
library(showtext)
library(ggtext)
library(glue)
library(lubridate)



episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/episodes.csv')