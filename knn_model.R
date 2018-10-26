library(caret)
library(ROCR)
library(dplyr)

# Fit KNN model the the training data and test it on the test data

knn_fit_results <- list()
knn_prediction_results <- list()
knn_auc_results <- NULL
knn_prop_malignant_results <- NULL 
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("knn_fit_result_set", i, sep = "")
	knn_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "knn"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("knn_predicted_class_set", i, sep = "")
	knn_prediction_results[[predicted_class_name]] <- predict(knn_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("knn_predicted_prob_set", i, sep = "") 
	knn_prediction_results[[predicted_prob_name]] <- predict(knn_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	knn_predicted_prob <- prediction(knn_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	knn_auc <- performance(knn_predicted_prob, "auc")
	knn_auc_results <- c(knn_auc_results, unlist(knn_auc@y.values ))
	# Calculate the proportion of M predicted
	knn_prop_malignant <- data.frame(pred_class = knn_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		knn_prop_malignant_results <- c(knn_prop_malignant_results, knn_prop_malignant$prop)
}
knn_prop_malignant_results 

