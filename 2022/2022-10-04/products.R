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
library(lubridate)

#Loading fonts
font_add_google(name = "Montserrat", family = "Montserrat")
font <- "Montserrat"

## turn on showtext
showtext_auto()

# Loading datasets
product_hunt <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-04/product_hunt.csv')

# Data Processing
product_cat <- product_hunt %>% 
  mutate(category_tags = str_to_title(str_remove_all(category_tags, "\\[|\\]|\\'"))) %>% #regular expression to remove the brackets and apostrophes #converts string case to title case
  separate_rows(category_tags, sep = ", ") #separates string into multiple rows by separator

tail(product_cat %>% 
  tabyl(release_date)) #to see the range of years in the dataset

df <- product_cat %>%
  #filter(year(release_date) %in% c(2019,2020,2021)) %>% 
  group_by(category_tags) %>% 
  summarise(avg_upvote = round(mean(upvotes)),
            sum_upvote = sum(upvotes)) %>%
  filter(sum_upvote > 1000000) %>% 
  arrange(desc(avg_upvote)) %>% 
  head(10) %>% 
  mutate(top_cat = category_tags=="Design Tools") 

df %>% 
  ggplot(aes(avg_upvote, reorder(category_tags, avg_upvote))) +
  geom_bar(stat="identity", aes(fill=top_cat)) +
  geom_text(data=df %>% filter(category_tags!="Design Tools"),aes(label=avg_upvote), hjust=-0.5, size = 5, family=font, color="gray70", fontface="bold") +
  geom_text(data=df %>% filter(category_tags=="Design Tools"), aes(label=avg_upvote), hjust=-0.5, size = 5, family=font, color="orange", fontface="bold") +
  scale_fill_manual(breaks = c(FALSE, TRUE),
                     values = c("gray70", "orange")) +
  expand_limits(x=500) +
  labs(title = "Average Number of Upvotes for Products on Product Hunt",
       subtitle = "<span style ='color:orange;'>Design tools </span> receive on average the highest number of upvotes out of product categories with more than 1M upvotes",
       x = "Average Number of Upvotes",
       caption =
         "Graphic: @gentiang\nSource: components.one by way of Data is Plural \nCode: gentiang/tidytuesday \n#rstats #tidytuesday") + 
  theme_minimal() +
  theme(plot.margin = margin(1,1,1.5,1.2, "cm"),
        axis.title = element_blank(),
        plot.title = element_text(size=25, face = "bold", family=font, color = "gray90", margin=margin(b=20)),
        plot.subtitle = element_markdown(size=15, family=font, color="gray90"),
        plot.caption = element_text(hjust = 1, size=12, family=font, face="italic", color="gray80", vjust=0.1, margin=margin(t=-60)),
        axis.text.y = element_text(size = 13, color = "gray90", family=font, face="bold"),
        axis.text.x = element_blank(),
        legend.key.size = unit(0.5, 'cm'), #change legend key size
        legend.position = "none",
        plot.title.position = "plot",
        panel.grid = element_blank(),
        panel.background = element_rect(fill="#1e3963", colour = "#1e3963"),
        plot.background = element_rect(fill="#1e3963", colour = "#1e3963"))