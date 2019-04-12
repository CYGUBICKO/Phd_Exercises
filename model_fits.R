library(caret)
set.seed(237)

# List the models to fit
models <- c("lda"
	, "qda"
	, "glm"
	, "rpart"
	, "bag"
	, "ranger"
	, "gbm"
	, "knn"
#	, "nb" 
	, "nnet"
)

fitted_models <- model_train_fit(models)
