library(caret)
set.seed(237)

# List the models to fit
models <- c(LDA = "lda"
	, QDA = "qda"
#	, GLM = "glm"
	, CT = "rpart"
	, BAG = "treebag"
	, RF = "ranger"
	, BOOST = "gbm"
	, KNN = "knn"
	, NB = "nb" 
	, NN = "nnet"
)

fitted_models <- model_train_fit(models)
