library(caret)
library(MASS)

# Here we fit LDA model to our training and test on the test data

ldaModel <- function(seed, part_ratio){
	wdbc_part <- dataPartition(seed, part_ratio)
	wdbc_train <- wdbc_part$wdbc_train
	wdbc_test <- wdbc_part$wdbc_test
	lda_model <- train(diagnosis~.,
		wdbc_train,
		method = "lda",
		metric = "ROC",
		preProc = c("center", "scale"),
		tuneLength = 10,
		trControl = model_control
	)

	# Predictions
	## We predict the classes on test data
	lda_predicted_class <- predict(lda_model, wdbc_test)

	# Predicted probabilities
	lda_predicted_prob <- predict(lda_model, 
		wdbc_test, 
		type = "prob"
	)
	return(
		list(
			wdbc_test = wdbc_test,
			lda_predicted_class = lda_predicted_class,
			lda_predicted_prob = lda_predicted_prob
		)
	)
}
