# Setting work directory
setwd("C:/Users/gashi/Desktop/TidyTuesday/2022/2022-09-27")

# Loading Libraries
library(tidyverse)
library(ggplot2)
library(janitor)
library(scales)
library(stringr)
library(ggbeeswarm)
library(showtext)
library(ggtext)
library(glue)

#Loading fonts
font_add_google(name = "Montserrat", family = "Montserrat")
font <- "Montserrat"

# turn on showtext --------------------------------------------------------
showtext_auto()

# Loading datasets
artists <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-27/artists.csv')


wc <- c("California", "Oregon", "Washington")
ec <- c("Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut", "New York", "New Jersey", "Delaware", "Maryland", "Virginia", "North Carolina"," South Carolina", "Georgia", "Florida")
cs <- c("California", "Oregon", "Washington", "Maine", "New Hampshire", "Massachusetts", "Rhode Island", "Connecticut", "New York", "New Jersey", "Delaware", "Maryland", "Virginia", "North Carolina"," South Carolina", "Georgia", "Florida")

artists %>%
  filter(state %in% cs) %>%
  mutate(race2 = case_when(race=="African-American" ~ "African-American",
                           race!="African-American" ~ "Other"),
         region = case_when(state %in% wc ~ "West Coast",
                            state %in% ec ~ "East Coast"),
         region = factor(region, levels = c("West Coast", "East Coast"))) %>%
  arrange(desc(race2)) %>% 
  ggplot(aes(fct_reorder(type, desc(type)), location_quotient, color=race2)) +
  geom_beeswarm(alpha=0.7, size=7) +
  scale_y_continuous("Location Quotient (Log2)", trans = "log2") +
  scale_color_manual(values = c("red", "grey70"),
                     breaks = c("African-American", "Other")) +
  coord_flip() +
  facet_wrap(~region) +
  labs(title = "<span style ='color:red;'>African-American </span>Artists in the East vs. West",
       subtitle = str_wrap(
         "The Location quotients (LQ) measure an artist occupation's concentration in the labor force,
  relative to the U.S. labor force share. For example, an LQ of 1.2 indicates that the state's
  labor force in an occupation is 20 percent greater than the occupation's national labor force
  share. An LQ of 0.8 indicates that the state's labor force in an occupation is 20 percent below
  the occupation's national labor force share. California has proportionally more artists in every
  category, paritcularly actors.", 130),
       caption = str_wrap(glue(
         "Graphic: @gentiang /
   Source: arts.gov by way of Data is Plural /
   Code: gentiang/tidytuesday #rstats #tidytuesday"), 1000)) +
  theme_minimal()+
  theme(axis.title = element_blank(),
        plot.margin=margin(1,1,1,1, unit="cm"),
        legend.position = "none",
        panel.background = element_rect(fill="#fcf4d4", colour = "#fcf4d4"),
        plot.background = element_rect(fill="#fcf4d4", colour = "#fcf4d4"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_line(color = "grey60", size = 0.15),
        plot.title = element_markdown(size = 40, hjust = 0, family = font, face = "bold"),
        plot.subtitle = element_text(size = 25, hjust = 0, family = font, lineheight = 0.5),
        plot.caption = element_text(family = font, face = "italic", size=20),
        axis.title.x = element_text(family = font, size=26, face = "bold"),
        axis.text = element_text(family = font, size=22, face = "bold"),
        strip.text = element_text(family = font, size=26, face = "bold"),
        plot.title.position = "plot")

ggsave("fig1.jpg")
