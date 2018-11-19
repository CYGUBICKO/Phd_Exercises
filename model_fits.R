library(caret)


# List the models to fit
models <- c(
	"rpart" 
	, "knn"
	, "nb" 
	, "ranger"
	, "nnet"
	, "lda"
	, "qda"
	, "glm"
)

fitted_models <- model_train_fit(models)