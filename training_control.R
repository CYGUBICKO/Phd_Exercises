library(caret)
set.seed(237)

# We use the trainControl function from caret package to control how the parameters in the training set are genretated : see ?trainControl

model_control <- trainControl(
	method = ctl_method
	, number = ctl_number
	, classProbs = ctl_classProb
	, summaryFunction = match.fun(summFunc)
	, allowParallel = TRUE
)
