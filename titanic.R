# Introduction to Data Science with R - Data Analysis Part 1
# Andrew Henning-Kolberg 2018-02-16

# Load raw data
train <- read.csv("train.csv", header = TRUE)
test <- read.csv("test.csv", header = TRUE)

# Add a "Survived" variable to the test set to allow for combining data sets
test.Survived <- data.frame(Survived = rep("None", nrow(test)), test[,])

# Combine data sets
data.combined <- rbind(train, test.Survived)

# A bit about data types (e.g. factors)
str(data.combined)

data.combined$Survived <- as.factor(data.combined$Survived)
data.combined$Pclass <- as.factor(data.combined$Pclass)

# Take a look at gross survival rates
table(data.combined$Survived)

# Distribution across classes
table(data.combined$Pclass)

# Load up ggplot2 to use for visualizations
library(ggplot2)

# Hypothesis - Rich folks survived at a higher rate
train$Pclass <- as.factor(train$Pclass)
ggplot(train, aes(x = Pclass, fill = factor(Survived))) +
  geom_bar(stat = "count") + 
  xlab("Pclass") +
  ylab("Total Count") +
  labs(fill = "Survived")

# Examine the first few names in the training data set
head(as.character(train$Name))

