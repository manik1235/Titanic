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

# How many unique names are there across both train & test?
length(unique(as.character(data.combined$Name)))

# Two duplicate names, take a closer look
# First get the duplicate names and store them as a vector
dup.name <- as.character(data.combined[which(duplicated(as.character(data.combined$Name))), "Name"])

# Next, take a look at the records in the combined data set
data.combined[which(data.combined$Name %in% dup.name),2]

# What is up with the "Miss." and "Mr." thing?
library(stringr)

# Any correlation with other variables (e.g. sibsp)?
misses <- data.combined[which(str_detect(data.combined$Name, "Miss.")),]
misses[1:5,]

# Hypothesis - Name titles correlate with age
mrses <- data.combined[which(str_detect(data.combined$Name, "Mrs.")),]
mrses[1:5,]

# Check out males to see if pattern continues
males <- data.combined[which(data.combined$Sex == 'male'),]
males[1:5,]
#length(males)
#males
#nrow(males)

# Expand upon the relationships between Survived, Pclass by creating a new 'Title' variable to the
# data set and the explore a potential 3-dimensional relationship.
extractTitle <- function(Name) {
  Name <- as.character(Name)
  
  if (length(grep("Miss.", Name)) > 0) {
    return ("Miss.")
  } else if (length(grep("Master.", Name)) > 0) {
    return ("Master.")
  } else if (length(grep("Mrs.", Name)) > 0) {
    return ("Mrs.")
  } else if (length(grep("Mr.", Name)) > 0) {
    return ("Mr.")
  } else {
    return ("Other")
  }
}

titles <- NULL
for (i in 1:nrow(data.combined)) {
  titles <- c(titles, extractTitle(data.combined[i, "Name"]))
}
data.combined$Title <- as.factor(titles)

# Since we only have survived lables for the train set, only use the 
# first 891 rows
ggplot(data.combined[1:891,], aes(x = Title, fill = Survived)) +
  geom_bar(stat = "count") +
  facet_wrap(~Pclass) +
  ggtitle("Pclass") +
  xlab("Title") +
  ylab("Total Count") +
  labs(fill = "Survived")

# Check out embarked
ggplot(data.combined[1:891,], aes(x = Title, fill = Survived)) +
  geom_bar(stat = "count") +
  facet_wrap(~Embarked) +
  ggtitle("Embarked") +
  xlab("Title") +
  ylab("Total Count") +
  labs(fill = "Survived")

# Look at the IndivFare
# IndivFare <- SibSp + Parch + 1
# Because the Fare represents their ticket + everyone
# they are traveling with.
IndivFare <- data.combined$Fare / (data.combined$SibSp + data.combined$Parch + 1)
IndivFare.rounded <- floor(IndivFare)
data.combined$IndivFareRounded <- as.integer(IndivFare.rounded)
data.combined$IndivFare <- as.double(IndivFare)
                       
# Plot the individual fare (rounded) and survival rate.
ggplot(data.combined[1:891,], aes(x = IndivFareRounded, fill = Survived)) +
  geom_freqpoly(stat = "count") +
  ggtitle("survival by fare") +
  xlab("Fare (rounded)") +
  ylab("Total Count") +
  labs(fill = "Survived")


          
ggplot(data.combined[1:891,], aes(x = Title, fill = Survived)) +
  geom_bar(stat = "count") +
  facet_wrap(~Embarked) +
  ggtitle("Embarked") +
  xlab("Fare") +
  ylab("Total Count") +
  labs(fill = "Survived")

