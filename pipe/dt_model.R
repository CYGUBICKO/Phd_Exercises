
library(caret)
library(ROCR)
library(dplyr)

# Here we fit DT model to our training and test on the test datasets

dt_fit_results <- list()
dt_prediction_results <- list()
dt_auc_results <- NULL
dt_prop_malignant_results <- NULL
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("dt_fit_result_set", i, sep = "")
	dt_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "rpart"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("dt_predicted_class_set", i, sep = "")
	dt_prediction_results[[predicted_class_name]] <- predict(dt_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("dt_predicted_prob_set", i, sep = "") 
	dt_prediction_results[[predicted_prob_name]] <- predict(dt_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	dt_predicted_prob <- prediction(dt_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	dt_auc <- performance(dt_predicted_prob, "auc")
	dt_auc_results <- c(dt_auc_results, unlist(dt_auc@y.values))
	# Calculate the proportion of M predicted
	dt_prop_malignant <- data.frame(pred_class = dt_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		dt_prop_malignant_results <- c(dt_prop_malignant_results, dt_prop_malignant$prop)
}

