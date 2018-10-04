library(caret)
library(ROCR)
library(dplyr)

# Here we fit LDA model to our training and test on the test datasets

lda_fit_results <- list()
lda_prediction_results <- list()
lda_auc_results <- NULL
lda_prop_malignant_results <- NULL
for (i in 1:length(seeds)){	
	wdbc_train <- partition_sets[[i]]$train
	wdbc_test <- partition_sets[[i]]$test
	result_name <- paste("lda_fit_result_set", i, sep = "")
	lda_fit_results[[result_name]] <- train(diagnosis~.
		, wdbc_train
		, method = "lda"
		, metric = "ROC"
		, preProc = c("center", "scale")
		, tuneLength = 10
		, trControl = model_control
	)
	# Predictions
	## We predict the classes on test data
	predicted_class_name <- paste("lda_predicted_class_set", i, sep = "")
	lda_prediction_results[[predicted_class_name]] <- predict(lda_fit_results[[result_name]]
  		, wdbc_test
	)
	# Predicted probabilities
	predicted_prob_name <- paste("lda_predicted_prob_set", i, sep = "") 
	lda_prediction_results[[predicted_prob_name]] <- predict(lda_fit_results[[result_name]]
  		, wdbc_test
		, type = "prob"
	)
	# Obtain the AUC metric
	lda_predicted_prob <- prediction(lda_prediction_results[[predicted_prob_name]][ ,2]
		, wdbc_test$diagnosis
	)
	lda_auc <- performance(lda_predicted_prob, "auc")
	lda_auc_results <- c(lda_auc_results, unlist(lda_auc@y.values))
	# Calculate the proportion of M predicted
	lda_prop_malignant <- data.frame(pred_class = lda_prediction_results[[predicted_class_name]]) %>%
		count(pred_class) %>% 
		mutate(prop = n/sum(n)) %>% 
		filter(pred_class == "M") %>% 
		select(prop)
		lda_prop_malignant_results <- c(lda_prop_malignant_results, lda_prop_malignant$prop)
}

