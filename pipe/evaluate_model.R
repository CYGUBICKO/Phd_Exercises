library(caret)
library(MASS)
library(ROCR)
library(corrplot)

# This script loops over the models for a given number of times with different set.seed values. This is our first attempt to compare the performance of the models on different samples of the data.

# Set up random numbers to be used in set.seed

part_ratio <- 0.75 # Ratio of training : test data
n_repeats <- 10 # Number of times to reselect the training and test data
adds <- sample(1:1000, n_repeats)
seeds <- seq(10, 10000, length.out = n_repeats) + adds

metrics_df <- data.frame(LDA_AUC = rep(NA, n_repeats),
                         QDA_AUC = rep(NA, n_repeats),
                         KNN_AUC = rep(NA, n_repeats),
                         NN_AUC = rep(NA, n_repeats)
)

for (i in 1:length(seeds)){
  seed <- seeds[[i]]
  # LDA
  lda_fit <- ldaModel(seed, part_ratio)
  lda_predict <- lda_fit$lda_predicted_prob
  wdbc_test <- lda_fit$wdbc_test
  lda_predicted_prob <- prediction(lda_predict[,2],
                                   wdbc_test$diagnosis
  )
  lda_auc <- performance(lda_predicted_prob, "auc")
  metrics_df$LDA_AUC[i] <- unlist(lda_auc@y.values )
  
  # QDA
  qda_fit <- qdaModel(seed, part_ratio)
  qda_predict <- qda_fit$qda_predicted_prob
  wdbc_test <- qda_fit$wdbc_test
  qda_predicted_prob <- prediction(qda_predict[,2],
                                   wdbc_test$diagnosis
  )
  qda_auc <- performance(qda_predicted_prob, "auc")
  metrics_df$QDA_AUC[i] <- unlist(qda_auc@y.values)
  
  # KNN
  knn_fit <- knnModel(seed, part_ratio)
  knn_predict <- knn_fit$knn_predicted_prob
  wdbc_test <- knn_fit$wdbc_test
  knn_predicted_prob <- prediction(knn_predict[,2],
                                   wdbc_test$diagnosis
  )
  knn_auc <- performance(knn_predicted_prob, "auc")
  metrics_df$KNN_AUC[i] <- unlist(knn_auc@y.values)
  
  # NN
  nn_fit <- nnModel(seed, part_ratio)
  nn_predict <- nn_fit$nn_predicted_prob
  wdbc_test <- nn_fit$wdbc_test
  nn_predicted_prob <- prediction(nn_predict[,2],
                                  wdbc_test$diagnosis
  )
  nn_auc <- performance(nn_predicted_prob, "auc")
  metrics_df$NN_AUC[i] <- unlist(nn_auc@y.values)
  
}

metrics_df

# Pearson correlation between the AUCs

corr <- cor(metrics_df, method = "spearman")
corr

png("model_metrics_corr.png")
corrplot(corr, method = "number", bg=1)
dev.off()

