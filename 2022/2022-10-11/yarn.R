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
library(ggdist)
library(MetBrewer)
library(cowplot)

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

top10 <- 
  yarn |> 
  group_by(yarn_company_name) |> 
  summarize(rate_avg = sum(rating_total)/sum(rating_count),
            rate_count = sum(rating_count)) |> 
  filter(rate_count > 10000) |> 
  arrange(desc(rate_avg)) |> 
  slice_head(n = 10)


df <- 
  yarn |> 
  filter(yarn_company_name %in% top10$yarn_company_name)


titles <- list(title = "Yarn manufacturers' rating according to Ravelry.com",
                subtitle = "Manufacturer's with more than 10k ratings from users",
                legend = "Graphic: @gentiang\nSource: ravelry.com by way of Alice Walsh \nCode: gentiang/tidytuesday \n#rstats #tidytuesday")


## Paleta ----------------------------------------------------------------


bg_col <- "#E3DACD"

grid_col <- "#795F4C"

text_col <- "#453330"



## Fonts -----------------------------------------------------------------


font_title <- "Montserrat"


font_text <- "Montserrat"


font_add_google(font_title, font_title)


font_add_google(font_text, font_text)


showtext_opts(dpi = 320)



## Visualization --------------------------------------------------------------


df |> 
  ggplot(aes(rating_average, 
             yarn_company_name,
             fill = yarn_company_name,
             color = yarn_company_name)) +
  stat_slab(scale = 0.75,
            alpha = 0.55,
            color = NA) +
  stat_dotsinterval(slab_color = "gray85", 
                    side = "bottom", scale = 0.7, 
                    show_interval = FALSE) +
  scale_x_continuous(limits = c(0, 5)) +
  scale_fill_met_d("Signac") +
  scale_color_met_d("Signac") +
  theme_void() +
  theme(axis.text = element_text(size = 10, 
                                 color = text_col),
        axis.text.y = element_text(hjust = 1),
        panel.grid.major = element_line(color = grid_col,
                                        size = 0.1),
        plot.background = element_rect(fill = bg_col,
                                       color = bg_col),
        plot.margin = margin(2, 2, 2, 2, "cm"),
        plot.title = element_text(family = font_title,
                                  size = 24,
                                  color = text_col),
        plot.subtitle = element_text(family = font_text,
                                     size = 18,
                                     color = "gray30",
                                     margin = margin(6, 0, 36, 0, "pt")),
        plot.title.position = "plot",
        plot.caption = element_text(family = font_text,
                                    size = 14, 
                                    face = "bold",
                                    color = text_col,
                                    hjust = 0.5,
                                    margin = margin(36, 0, 0, 0, "pt")),
        plot.caption.position = "plot",
        legend.position = "none") +
  labs(
    title = titles$título,
    subtitle = titles$subtitle,
    caption = titles$legend
  )

# Export ---------------------------------------------------


ggsave("yarn.png", 
       width = 5120, height = 2880, dpi = 320, units = "px")
