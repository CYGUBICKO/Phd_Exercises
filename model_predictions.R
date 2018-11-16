library(caret)
library(ROCR)
library(tidyr)
library(ggplot2)
library(dplyr)
library(ROCR)
theme_set(theme_bw())

# Predictions
obs_pred_df <- list()
prob_pred_df <- list()
roc_df <- list()
for (i in 1:length(fitted_models)){
	# Predicted class
	model = gsub("_fit", "", names(fitted_models)[i])
	obs_pred_df[[names(fitted_models)[i]]] <- data.frame(
		model = model
		, obs = test_df$diagnosis
		, pred = predict(
				fitted_models[[i]]
				, test_df
			)
	)
	
	# Predicted Probabilities
	prob_pred_df[[names(fitted_models)[i]]] <- (
		predict(fitted_models[[i]]
			, test_df
			, type = "prob"
		)
		%>% mutate(model = model)
		%>% mutate(obs_diag = test_df$diagnosis)
	)

	# Extract ROCs based on the predictions
	rocr_pred <- prediction(prob_pred_df[[names(fitted_models)[i]]][,2]
		, test_df$diagnosis
	)
	model_roc <- performance(rocr_pred
		, "tpr"
		, "fpr"
		)
	roc_df[[names(fitted_models)[i]]] <- data.frame(model = model
		, x = model_roc@x.values[[1]]
		, y = model_roc@y.values[[1]]
	)
}

# Format data outputs
## Class predictions
obs_pred_df <- (Reduce(rbind, obs_pred_df)
	%>% gather(Observation, Diagnosis, -model)
)

## Determine the count of cases which were observed to be M in the test data
obs_count <-(test_df
	%>% filter(diagnosis=="M")
	%>% tally()
)
## Plot
print(
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


## Predicted probabilities
prob_pred_df <- (Reduce(rbind, prob_pred_df)
	%>% gather(pred_diag, prob, -model, -obs_diag)
	%>% filter(pred_diag=="M")
)

print(
	ggplot(prob_pred_df, aes(x = reorder(obs_diag, -prob), y = prob)
	)
	+ geom_boxplot(varwidth = TRUE, fill = "plum")
	+ facet_wrap(~model, scales = "free")
	+ labs(title = "Probability of predicting observed correctly having predicted 'M'"
		, x = "Observed diagnosis"
		, fill = "Predicted probability"
		)
)

print(
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

# AUC curves
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
		+ geom_boxplot()
		+ labs(title = "AUC comparison"
			, x = "Model"
			, y = "AUC"
		)
)

# ROC curves
roc_df <- Reduce(rbind, roc_df)

print(
	ggplot(roc_df, aes(x = x, y = y, group = model, colour = model))
	+ geom_line()
	+ scale_x_continuous(limits = c(0, 0.2))
	+ scale_colour_manual(values = sample(colours(), length(levels(roc_df$model))))
	+ scale_y_continuous(limits = c(0.8, 1))
	+ labs(title = "ROCs comparison"
		, x = "False positive rate"
		, y = "True positive rate"
		)
)


