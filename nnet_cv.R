library(nnet)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

cv_df <- train_df
wt_decay <- c(0.00001, .01, .1, .2, .3, .4, .5, 1, 2)
n_folds <- 10
n_train <- nrow(cv_df)
folds_i <- sample(rep(1:n_folds, length.out = n_train))
cv_pred_error <- matrix(NA, nrow = n_folds, ncol = length(wt_decay))
for (i in 1:length(wt_decay)){
  for (k in 1:n_folds) {
    index <- which(folds_i == k)
    cv_train_df <- cv_df[-index, ]
    cv_test_df <- cv_df[index, ]
    nnet_Model <- nnet(diagnosis ~ .
                       , data = cv_train_df
                       , size = 8
                       , decay = wt_decay[[i]]
                       , maxit = 500
                       , MaxNWts = 2000
                       , trace = FALSE
    )
    nn_pred <- predict(nnet_Model, cv_test_df, type = "class")
    # Cross validation error (proportion)
    cv_pred_error[k, i] <- 1 - mean(nn_pred==cv_test_df$diagnosis)
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
  + geom_line()
  + geom_point()
  + labs(title = "CV Error"
         , x = "Weight Decay"
         , y = "Prop. incorrect prediction"
  )
)
