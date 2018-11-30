library(nnet)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

set.seed(4133)
## wt_decay <- c(0.00001, .01, .1, .2, .3, .4, .5, 1, 2)
wt_decay <- exp(seq(-5, 0))

cv_df <- train_df
n_folds <- 10
inner_reps <- 5
n_train <- nrow(cv_df)
cv_pred_error <- matrix(0, nrow = n_folds, ncol = length(wt_decay))

for (w in 1:length(wt_decay)){
	for (f in 1:n_folds) {
		for (r in 1:inner_reps){
			folds_i <- sample(rep(1:n_folds, length.out = n_train))
			index <- which(folds_i == f)
			train <- cv_df[-index, ]
			test <- cv_df[index, ]
			nnet_Model <- nnet(diagnosis ~ .
				, data = train
				, size = 8
				, decay = wt_decay[[w]]
				, maxit = 500
				, MaxNWts = 2000
				, trace = FALSE
			)
			nn_pred <- predict(nnet_Model, test, type = "class")
			# Cross validation error (proportion)
			cv_pred_error[f, w] <- (cv_pred_error[f, w] 
				+ (1 - mean(nn_pred==test$diagnosis))/inner_reps
			)
		}
	}
}

cv_result <- data.frame(Decay = wt_decay
												, Error = colMeans(cv_pred_error)
)
print(
	ggplot(cv_result, 
				aes(x = Decay
						, y = Error
				)
	)
	+ scale_x_log10()
	+ geom_line()
	+ geom_point()
	+ labs(title = "CV Error"
				, x = "Weight Decay"
				, y = "Prop. incorrect prediction"
	)
)
