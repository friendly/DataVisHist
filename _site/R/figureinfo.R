#' ---
#' title: "Merge list of figure filenames with captions"
#' author: "Michael Friendly"
#' date: "17 Sep 2019"
#' ---


setwd("C:/Dropbox/Documents/TOGS")
#setwd("C:/Users/friendly/Dropbox/Documents/TOGS")
#load(".RData")

library(readr)
library(dplyr)
library(tidyr)
library(stringr)
#library(xlsx)

# 
# art_log <- read.xlsx(file="art_log.xlsx", sheetName = "figinfo") %>%
#     select(c(-type, -class, -format))

library(readxl)
art_log <- read_excel("art_log.xlsx") %>%
     select(c(-type, -class, -format))
  
sources <- read_excel("art_log.xlsx", sheet="sources") %>%
     select(c(-codes, -status, -URL))

TOGS_lof <- read_delim("TOGS-lof.tsv", "\t", 
                       escape_double = FALSE, col_types = cols(fignum = col_character()), 
                       trim_ws = TRUE)

TOGS_lof <- TOGS_lof %>%
  mutate(fignum = if_else(fignum =="1", "0.1", fignum ))


figureinfo <- right_join(TOGS_lof, art_log, by="fignum")  # keeps all
figureinfo <- right_join(figureinfo, sources, by="fignum") 
chapter <- as.numeric(sub("\\.\\d+", "", figureinfo$fignum))
figureinfo <- bind_cols(chapter=chapter, figureinfo)

save(figureinfo, file="figureinfo.RData")




			

