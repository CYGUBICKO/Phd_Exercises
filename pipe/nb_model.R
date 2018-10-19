library(caret)
library(ROCR)
library(dplyr)

# Fit Naive Bayes model the the training data and test it on the test data

nb_fit_results <- list()
nb_prediction_results <- list()
nb_auc_results <- NULL
nb_prop_malignant_results <- NULL 
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("nb_fit_result_set", i, sep = "")
	nb_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "nb"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, trace = FALSE
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("nb_predicted_class_set", i, sep = "")
	nb_prediction_results[[predicted_class_name]] <- predict(nb_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("nb_predicted_prob_set", i, sep = "") 
	nb_prediction_results[[predicted_prob_name]] <- predict(nb_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	nb_predicted_prob <- prediction(nb_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	nb_auc <- performance(nb_predicted_prob, "auc")
	nb_auc_results <- c(nb_auc_results, unlist(nb_auc@y.values ))
	# Calculate the proportion of M predicted
	nb_prop_malignant <- data.frame(pred_class = nb_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		nb_prop_malignant_results <- c(nb_prop_malignant_results, nb_prop_malignant$prop)
}
nb_prop_malignant_results 
