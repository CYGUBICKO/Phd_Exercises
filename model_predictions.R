library(caret)
library(tidyr)
library(ggplot2)
library(dplyr)
library(ROCR)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Predictions
n_models <- length(fitted_models)
test_measures_df <- data.frame(Model = rep(NA, n_models)
	, Accuracy = rep(NA, n_models)
	, Sensitivity = rep(NA, n_models)
	, Specificity = rep(NA, n_models)
	, AUC = rep(NA, n_models)
)
obs_pred_df <- list()
prob_pred_df <- list()
roc_df <- list()
auc_vals <- list()
for (i in 1:n_models){
	set.seed(257)
	model = gsub("_fit", "", names(fitted_models)[i])
	# Model prediction
	predicted <- predict(fitted_models[[i]], test_df)
	confusion_mat <- confusionMatrix(predicted, test_df$diagnosis, positive = "M")
	# Predicted class
	obs_pred_df[[model]] <- data.frame(
		model = model
		, obs = test_df$diagnosis
		, pred = predicted
	)
	
	# Predicted Probabilities
	prob_pred_df[[model]] <- (
		predict(fitted_models[[i]]
			, test_df
			, type = "prob"
		)
		%>% mutate(model = model)
		%>% mutate(obs_diag = test_df$diagnosis)
	)

	# Extract ROCs based on the predictions
	rocr_pred <- prediction(prob_pred_df[[model]][,2]
		, test_df$diagnosis
	)
	model_roc <- performance(rocr_pred
		, "tpr"
		, "fpr"
		)
	roc_df[[model]] <- data.frame(model = model
		, x = model_roc@x.values[[1]]
		, y = model_roc@y.values[[1]]
	)
	auc_vals[[model]] <- performance(rocr_pred
		, "auc" 
	)@y.values[[1]]
	
	# Put together all performance measures
	test_measures_df[["Model"]][[i]] <- model
	test_measures_df[["Accuracy"]][[i]] <- confusion_mat$overall[[1]]
	test_measures_df[["Sensitivity"]][[i]] <- confusion_mat$byClass[[1]]
	test_measures_df[["Specificity"]][[i]] <- confusion_mat$byClass[[2]]
	test_measures_df[["AUC"]][[i]] <- auc_vals[[model]]
}

# Format data outputs
## Class predictions
obs_pred_df1 <- Reduce(rbind, obs_pred_df)

obs_pred_df <- (obs_pred_df1
	%>% gather(Observation, Diagnosis, -model)
)

## Determine the count of cases which were observed to be M in the test data
obs_count <-(test_df
	%>% filter(diagnosis=="M")
	%>% tally()
)
## Plot
obs_pred_plot <- (
	obs_pred_df 
		%>% filter(Observation=="pred")
		%>% ggplot(aes(x = model, fill = Diagnosis)) 
		 	+ geom_bar(stat="count")
			+ geom_hline(yintercept = obs_count[[1]]
				, linetype = "dashed"
				, size = 1
				)
			+ labs(title = "No. of predictions by different models"
				, y = "Count"
				, x = "Model"
				)
)
obs_pred_plot

## Predicted probabilities
prob_pred_df1 <- prob_pred_df
prob_pred_df1

prob_pred_df <- (Reduce(rbind, prob_pred_df1)
	%>% gather(pred_diag, prob, -model, -obs_diag)
	%>% filter(pred_diag=="M")
)

prob_pred_plot1 <- (
	ggplot(prob_pred_df, aes(x = reorder(obs_diag, -prob), y = prob)
	)
	+ geom_boxplot(varwidth = TRUE, fill = "plum")
	+ facet_wrap(~model, scales = "free")
	+ labs(title = "Probability of predicting observed correctly having predicted 'M'"
		, x = "Observed diagnosis"
		, fill = "Predicted probability"
		)
)
prob_pred_plot1 

prob_pred_plot2 <- (
	ggplot(prob_pred_df)
	+ geom_density(aes(x = prob, y = ..scaled.., fill = factor(obs_diag))
		, alpha = 0.8
		, n = 32
		)
	+ facet_wrap(~model, scales = "free")
	+ labs(title = "Predicted Probabilities"
		, x = "Probabilities"
		, fill = "Observed Diagnosis"
	)
)
prob_pred_plot2

# AUC curves

col_scheme <- sample(colours(), length(models))

model_resamples <- resamples(fitted_models)
resample_df <- model_resamples$values

old_names <- grep("Res|ROC", names(resample_df), value = TRUE)
new_names <- gsub("~ROC|_fit", "", old_names)
auc_df <- (resample_df
	%>% select(old_names)
	%>% setNames(new_names)
	%>% gather(Model, AUC, -Resample)
)

print(
	ggplot(auc_df
		, aes(x = reorder(Model, -AUC), y = AUC, colour = Model)
		)
		+ geom_boxplot(outlier.colour=NULL)
		+ scale_colour_brewer(palette="Set1")
		+ labs(title = "AUC comparison"
			, x = "Model"
			, y = "AUC"
		)
)


# ROC curves
roc_df <- Reduce(rbind, roc_df)
roc_plot <- (
	ggplot(roc_df, aes(x = x, y = y, group = model, colour = model))
	+ geom_line()
	+ scale_x_continuous(limits = c(0, 1))
	+ scale_y_continuous(limits = c(0, 1))
	+ scale_colour_brewer(palette="Set1")
	+ labs(title = "ROCs comparison"
		, x = "False positive rate"
		, y = "True positive rate"
		)
)
roc_plot

