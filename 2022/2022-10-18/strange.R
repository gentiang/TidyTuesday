# Loading Libraries
library(tidyverse)
library(ggplot2)
library(janitor)
library(showtext)
library(ggtext)
library(glue)
library(tidytext)
library(ggwordcloud)

#Loading fonts
font_add_google(name = "Baskervville", family = "Baskervville")
font <- "Baskervville"

## turn on showtext
showtext_auto()

episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/episodes.csv')
lines <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv')

dialogue_clean <- lines %>% 
  select(dialogue, season, episode, line) %>% 
  unnest_tokens(word, dialogue) %>% 
  anti_join(stop_words, by = "word") %>%
  na.omit() %>% 
  count(word)

dialogue_sentiment <- dialogue_clean %>% 
  inner_join(get_sentiments("bing"), by = "word") %>%
  arrange(desc(n))

tbl <- dialogue_sentiment %>% 
  tabyl(sentiment) %>% 
  adorn_pct_formatting()

dialogue_sentiment %>%
  ggplot(aes(label=word, size=n, color=sentiment)) +
  geom_text_wordcloud_area(shape="circle", rm_outside = T, family=font) +
  scale_size_area(max_size = 25) +
  scale_color_manual(values = c("darkred", "steelblue"), breaks = c("negative", "positive")) +
  labs(title = "A Huge Pile of Shit",
       subtitle = glue("{tbl[1,3]} of all Stranger Things dialogue shows negative sentiment"),
       caption =
         "Graphic: @gentiang\nSource: 8flix.com - prepped by Dan Fellowes & Jonathan Kitt \nCode: gentiang/tidytuesday \n#rstats #tidytuesday") +
  theme_minimal() +
  theme(plot.margin = margin(1,1,1,1, "cm"),
        panel.background = element_rect(fill="black", colour = "black"),
        plot.background = element_rect(fill="black", colour = "black"),
        plot.title = element_text(color="white", size=40, face = "bold", family=font),
        plot.subtitle = element_text(color="white", size=30, face="italic", family=font),
        plot.caption = element_text(color="white", hjust = 1, size=12, face="italic", family=font))
