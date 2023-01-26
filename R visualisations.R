#View data
read.csv(team_stats)
View(team_stats)
col(team_stats)
str(team_stats)

#install packages
install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
install.packages("knitr")
install.packages("rmarkdown")
library(knitr)
library(markdown)

#basic scatter plot
ggplot(data = team_stats) +
  geom_point(mapping = aes(x = avg_FG, y = win_PCT)) 
           
           
#earliest season
mindate <- min(team_stats$SEASON)

#latest season
maxdate <- max(team_stats$SEASON)

#1.scatter plot smooth line - avg_FG
ggplot(data = team_stats, aes(x = avg_FG, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Field Goal%", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
  x = "Average FG%",
  Y = "Win%")

#2.scatter plot smooth line - avg_FT
ggplot(data = team_stats, aes(x = avg_FT, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Free Throw%", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
       x = "Average FT%",
       Y = 'Win%')

#3.scatter plot smooth line - avg_AST
ggplot(data = team_stats, aes(x = avg_AST, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Assists Per Game", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
       x = "Assists",
       Y = 'Win%')

#4.scatter plot smooth line - avg_FG3
ggplot(data = team_stats, aes(x = avg_FG3, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Three Pointers Per Game", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
       x = "3PG%",
       Y = 'Win%')


#5.scatter plot smooth line - avg_PTS
ggplot(data = team_stats, aes(x = avg_PTS, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Points Per Game", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
       x = "PPG",
       Y = 'Win%')

#6.scatter plot smooth line - avg_REB
ggplot(data = team_stats, aes(x = avg_REB, y = win_PCT, )) +
  geom_point() + 
  geom_smooth() +
  labs(title = "Rebounds Per Game", caption = paste0("Based on seasons: ", mindate, " to ", maxdate),
       x = "Rebounds",
       Y = 'Win%')
