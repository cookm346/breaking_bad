library(rvest)

links_1 <- read_html("https://transcripts.foreverdreaming.org/viewforum.php?f=165")
links_1 <- html_attr(html_nodes(links_1, "a"), "href")
links_1 <- links_1[27:51]

links_2 <- read_html("https://transcripts.foreverdreaming.org/viewforum.php?f=165&start=25")
links_2 <- html_attr(html_nodes(links_2, "a"), "href")
links_2 <- links_2[28:52]

links_3 <- read_html("https://transcripts.foreverdreaming.org/viewforum.php?f=165&start=50")
links_3 <- html_attr(html_nodes(links_3, "a"), "href")
links_3 <- links_3[28:39]

links <- c(links_1, links_2, links_3)

all_text <- list()

for(i in 1:length(links)){
    page <- read_html(paste0("https://transcripts.foreverdreaming.org", 
                             substring(links[i], 2, nchar(links[i]))), encoding = "UTF-8")
    all_text[[i]] <- html_text(html_nodes(page, "p"))
    Sys.sleep(10)
}

save(all_text, file="data/all_text.RData")
