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

std <- data.frame(apply(traindata, 2, sd))

Remove rows in train set with NAs if any
traindata <- traindata[complete.cases(traindata),]

Create a model with random forest for a better than linear regression
model
modFit <- randomForest(classe ~ ., data=traindata)
conf <- modFit$confusion
confdata <- data.frame(row.names(conf)[1:5],conf[,"class.error"])
names(confdata) <- c("Activity","Error.Rate")
barplot(confdata$Error.Rate, main="Error Rates", xlab="Activity", ylab="Error Rate", 
        names.arg=confdata$Activity,border="blue")


Calculate the confidence interval:



library(rattle)
fancyRpartPlot(modFit$finalModel)

Create character vector of predictions
predictions <- predict(modFit,testdata)
predictions <- as.character(predictions)

pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("answers/problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}

pml_write_files(predictions)