library(caret)

model_train_fit <- function(train_methods){
	fit_result <- list()
	for (train_method in train_methods){
	seed
		fit_name <- paste(train_method, "_", "fit", sep = "")
		tryCatch(
			if (train_method=="nnet"){
				fit_result[[fit_name]] <- train(
					diagnosis ~ .
						, data = train_df
						, method = train_method
						, metric = train_metric
						, preProc = train_preProc
						, tuneLength = train_tuneLength
						, trControl = model_control
						, trace = FALSE 
				)
			} 
			else{
				seed
				fit_result[[fit_name]] <- train(
					diagnosis ~ .
						, data = train_df
						, method = train_method
						, metric = train_metric
						, preProc = train_preProc
						, tuneLength = train_tuneLength
						, trControl = model_control
				)
			}
			, error = function(e){print(e)}
		)
	}
	return(fit_result)
}
