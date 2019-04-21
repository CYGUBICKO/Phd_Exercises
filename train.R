library(caret)

model_train_fit <- function(train_methods){
	fit_result <- list()
	for (m in 1:length(train_methods)){
	set.seed(257)
		fit_name <- paste(names(train_methods)[[m]], "_", "fit", sep = "")
		tryCatch(
			if (train_methods[[m]]=="nnet"){
				fit_result[[fit_name]] <- train(
					diagnosis ~ .
						, data = train_df
						, method = train_methods[[m]]
						, metric = train_metric
						, preProc = train_preProc
						, tuneLength = train_tuneLength
						, trControl = model_control
						, trace = FALSE 
				)
			} 
			else{
				set.seed(257)
				fit_result[[fit_name]] <- train(
					diagnosis ~ .
						, data = train_df
						, method = train_methods[[m]]
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
