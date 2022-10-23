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
library(tidytext)



episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/episodes.csv')
lines <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv')

dialogue_clean <- lines |>
  select(dialogue, season, episode, line) |>
  unnest_tokens(word, dialogue) |>
  anti_join(get_stopwords(), by = "word") |>
  na.omit()


stranger_things_dialogue <- lines %>%
  unnest_tokens(word, dialogue) %>%
  filter(!is.na(word)) %>%
  anti_join(stop_words, by = "word") %>%
  count(season, episode, start_time, word) %>%
  mutate(start_time = lubridate::minute(start_time))
