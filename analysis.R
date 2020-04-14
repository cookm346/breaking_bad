# install.packages("devtools")
library(devtools)

# install_github("cookm346/textfeats")
library(textfeats)

# install.packages("ggplot2")
library(ggplot2)

data <- read.csv("data/breaking_bad.csv", stringsAsFactors = FALSE)
data <- data.frame(episode=1:62,
                   data, 
                   count(data$text),
                   warriner(data$text),
                   concreteness(data$text),
                   pos(data$text))
data$season <- as.factor(data$season)
data <- data[ , apply(data, 2, function(x){!all(x == 0)})]

cor(data[ , ! colnames(data) %in% c("title", "season", "text")])

ggplot(data, aes(episode, valence)) + geom_line(size=2, aes(color=season)) + 
    geom_text(aes(label=title),hjust=0, vjust=0)
ggplot(data, aes(episode, arousal, color=season)) + geom_line(size=2)
ggplot(data, aes(episode, dominance, color=season)) + geom_line(size=2)

ggplot(data, aes(episode, rating)) + geom_line(size=2, aes(color=season)) + 
    geom_text(aes(label=title),hjust=0, vjust=0) +
    geom_smooth()


# load(url("http://www.lingexp.uni-tuebingen.de/z2/LSAspaces/TASA.rda"))
sem <- semantics(data$text, TASA)
pca <- prcomp(sem, center = TRUE, scale. = TRUE)
sem <- pca$x[ , 1:2]
sem <- data.frame(data, sem)

ggplot(sem, aes(PC1, PC2)) + geom_point(aes(color=season, size=rating)) + 
    geom_text(aes(label=title),hjust=0, vjust=0)

# install.packages("caret")
library(caret)

train_data <- data.frame(season = data$season, sem)
train_data <- downSample(train_data, class_data$season)
train_data$Class <- NULL

tc <- trainControl(method='cv', number=10)

set.seed(2020)
knnmodel <- train(season ~ ., data=train_data, 
                  method='knn', 
                  tuneGrid=expand.grid(.k=seq(1, 30, 2)), 
                  metric='Accuracy', 
                  trControl=tc,
                  preProc=c("center", "scale"))

plot(knnmodel)
confusionMatrix(knnmodel)

svmmodel <- train(season ~ ., data=train_data, 
                 method='svmRadial', 
                 metric='Accuracy', 
                 trControl=tc,
                 preProc=c("center", "scale"))

plot(svmmodel)
confusionMatrix(svmmodel)


rfmodel <- train(season ~ ., data=train_data, 
                  method='rf', 
                  metric='Accuracy', 
                  trControl=tc,
                  preProc=c("center", "scale"))

plot(rfmodel)
confusionMatrix(rfmodel)

