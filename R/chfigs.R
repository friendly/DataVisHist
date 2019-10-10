# Load packages
# do I need all of these??

library(dplyr)
library(tidyr)
library(stringr)
library(glue)
library(htmltools)

# load the data set giving info about figures. This was created using the figureinfo.R script 

load("data/figureinfo.RData")


# define templates-- these aren't actually used here because I couldn't make them work with glue
figrow_start <- '
<div class="row">
  <h3>Selected figures</h3>
'

figrow_end <- '
</div> <!-- row -->
'

media_list_begin <- '
  <div class="col-md-12">
    <ul class="media-list">
'

media_list_end <- '
    </ul> <!-- media-list -->
  </div> <!-- col-md-12 -->
'

media_item <- '
      <li class="media">
        <div class="media-left">
          <a href="#">
            <img class="media-object" src="%file%" width="250" alt="...">
          </a>
        </div>
        <div class="media-body">
          <h4 class="media-heading">Figure %fignum%</h4>
          %caption%
        </div>
      </li>
'

# Retrieve the figure info for figures in one chapter.
# I tried in here to format some of the fields, but was unsuccessful in these attempts.

chapter_figs <- function(ch) {
	figlist <- figureinfo %>% filter(chapter == ch)
	figlist$caption <- paste0("<strong>", figlist$maintitle, "</strong> ",
	                          figlist$subtitle)
	figlist$caption <-sub("NA", "", figlist$caption) 
# 	figlist <- figlist %>%
# #   	mutate(caption = paste(strong(maintitle),
# # 	                         subtitle)) 
#     mutate(caption= glue_data("<strong>{maintitle}</strong> {subtitle}"))
# #	  str_remove("NA")

	figlist
}


# chapter_figs(1)$caption


# an old function using templates, no longer used here
one_fig <- function(fignum) {
	fignum <- unlist(str_split(file, '-'))[1]
	fignum <- sub('_', '.', fignum, fixed=TRUE)
	text <- sub("%file%", file, media_item, fixed=TRUE)
	text <- sub("%fignum%", fignum, text, fixed=TRUE)
	text
}

# Finally...
# the function to use for each chapter.
#
# This depends on bootstrap classes and fancybox, but not sure where this is defined.

fig_dir <- "fig/"  # prepend to image {filepath}

do_chapter <- function(ch, thumbwidth=250) {
  figlist <- chapter_figs(ch)

	text <- figlist %>% 
	  glue_data('
	  
      <li class="media">
        <div class="media-left">
          <a href="{filepath}"  class="fancybox">
            <img class="media-object" src="{fig_dir}{filepath}" width="{thumbwidth}" alt="...">
          </a>
        </div>
        <div class="media-body">
          <h4 class="media-heading">Figure {fignum}</h4>
          {caption} <br/>
          <em>Source:</em> {sourcestring}
        </div>
      </li>
  ', '\n'
	)
	text <- cat(media_list_begin, text, media_list_end)
	text
}

#do_chapter(1)

