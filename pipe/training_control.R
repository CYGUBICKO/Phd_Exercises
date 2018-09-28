library(caret)

# We use the trainControl function from caret package to control how the parameters in the training set are genretated : see ?trainControl

model_control <- trainControl(method = "cv",
	number = 10,
	classProbs = TRUE,
	summaryFunction = twoClassSummary
)
