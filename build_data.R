load("data/all_text.RData")
all_text <- lapply(all_text, function(x){
    return(x[3:(length(x)-3)])
})
all_text <- sapply(all_text, paste, collapse = " ")

library(rvest)

ratings <- NULL
titles <- NULL

for(i in 1:5){
    page <- read_html(paste0("https://www.imdb.com/title/tt0903747/episodes?season=", i))
    rate <- html_text(html_nodes(page, ".ipl-rating-star__rating"))
    rate <- rate[seq(1, length(rate), 23)]
    ratings <- c(ratings, rate)
    
    title <- html_text(html_nodes(page, "strong"))
    title <- title[1:length(rate)]
    titles <- c(titles, title)
}

data <- data.frame(title = titles, 
                   season = rep(1:5, c(7, 13, 13, 13, 16)),
                   rating = ratings,
                   text = all_text)

write.csv(data, "data/breaking_bad.csv", row.names = FALSE)
