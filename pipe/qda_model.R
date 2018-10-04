library(caret)
library(ROCR)
library(dplyr)

# Fit QDA model to our training and test on the test data
qda_fit_results <- list()
qda_prediction_results <- list()
qda_auc_results <- NULL
qda_prop_malignant_results <- NULL
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("qda_fit_result_set", i, sep = "")
	qda_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "qda"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("qda_predicted_class_set", i, sep = "")
	qda_prediction_results[[predicted_class_name]] <- predict(qda_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("qda_predicted_prob_set", i, sep = "") 
	qda_prediction_results[[predicted_prob_name]] <- predict(qda_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	qda_predicted_prob <- prediction(qda_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	qda_auc <- performance(qda_predicted_prob, "auc")
	qda_auc_results <- c(qda_auc_results, unlist(qda_auc@y.values))
	# Calculate the proportion of M predicted
	qda_prop_malignant <- data.frame(pred_class = qda_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		qda_prop_malignant_results <- c(qda_prop_malignant_results, qda_prop_malignant$prop)
}
