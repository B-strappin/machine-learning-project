library(data.table)
traindata <- read.csv("pml-training.csv", stringsAsFactors=FALSE, na.strings=c("NA",""))
testdata <- read.csv("pml-testing.csv", stringsAsFactors=FALSE, na.strings=c("NA",""))

Make classe variable in training dataset factor
traindata$classe <- as.factor(traindata$classe)

Get rid of columns with all NAs
traindata <- traindata[,complete.cases(t(traindata))]
testdata <- testdata[,complete.cases(t(testdata))]

Get rid of columns that are not measurements
traindata <- traindata[,-c(1:7)]
testdata <- testdata[,-c(1:7)]

Remove rows in train set with NAs if any
traindata <- traindata[complete.cases(traindata),]

Create a model with random forest for a better than linear regression
model
modFit <- randomForest(classe ~ ., data=traindata)

Create character vector of predictions
predictions <- predict(modFit,testdata)
predictions <- as.character(predictions)

