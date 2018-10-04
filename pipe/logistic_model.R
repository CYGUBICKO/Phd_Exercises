library(caret)
library(ROCR)
library(dplyr)

# Fit logistic model the the training data and test it on the test data

logistic_fit_results <- list()
logistic_prediction_results <- list()
logistic_auc_results <- NULL 
logistic_prop_malignant_results <- NULL 
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("logistic_fit_result_set", i, sep = "")
	logistic_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "glm"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
		, family = "binomial"
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("logistic_predicted_class_set", i, sep = "")
	logistic_prediction_results[[predicted_class_name]] <- predict(logistic_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("logistic_predicted_prob_set", i, sep = "") 
	logistic_prediction_results[[predicted_prob_name]] <- predict(logistic_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	logistic_predicted_prob <- prediction(logistic_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	logistic_auc <- performance(logistic_predicted_prob, "auc")
	logistic_auc_results <- c(logistic_auc_results, unlist(logistic_auc@y.values))
	# Calculate the proportion of M predicted
	logistic_prop_malignant <- data.frame(pred_class = logistic_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		logistic_prop_malignant_results <- c(logistic_prop_malignant_results, logistic_prop_malignant$prop)
}
logistic_prop_malignant_results 


