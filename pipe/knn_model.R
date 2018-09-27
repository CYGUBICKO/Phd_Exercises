library(caret)
library(ROCR)

# Fit KNN model the the training data and test it on the test data
knnModel <- function(seed, part_ratio){
  wdbc_part <- dataPartition(seed, part_ratio)
  wdbc_train <- wdbc_part$wdbc_train
  wdbc_test <- wdbc_part$wdbc_test
  knn_model <- train(diagnosis~.,
                     wdbc_train,
                     method = "knn",
                     metric = "ROC",
                     preProcess = c("center", "scale"),
                     tuneLength = 10,
                     trControl = model_control
  )
  # Predictions
  ## We predict the classes on test data
  knn_predicted_class <- predict(knn_model,
                                 wdbc_test
  )
  # Predicted probabilities
  knn_predicted_prob <- predict(knn_model,
                                wdbc_test,
                                type = "prob"
  )
  return(
    list(
      wdbc_test = wdbc_test,
      knn_predicted_class = knn_predicted_class,
      knn_predicted_prob = knn_predicted_prob
    )
  )
}
