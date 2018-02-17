

# Load raw data
train <- read.csv("train.csv", header = TRUE)
test <- read.csv("test.csv", header = TRUE)

# Add a "Survived" variable to the test set to allow for combining data sets
test.Survived <- data.frame(Survived = rep("None", nrow(test)), test[,])

# Combine data sets
data.combined <- rbind(train, test.Survived)

