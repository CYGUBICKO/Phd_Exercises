library(caret)
library(ROCR)

# Fit Nearal Networks model the the training data and test it on the test data

nnModel <- function(seed, part_ratio){
  wdbc_part <- dataPartition(seed, part_ratio)
  wdbc_train <- wdbc_part$wdbc_train
  wdbc_test <- wdbc_part$wdbc_test
  nn_model <- train(diagnosis~.,
                    wdbc_train,
                    method = "nnet",
                    metric = "ROC",
                    preProcess = c("center", "scale"),
                    trace = FALSE,
                    tuneLength = 10,
                    trControl = model_control
  )
  # Predictions
  ## We predict the classes on test data
  nn_predicted_class <- predict(nn_model,
                                 wdbc_test
  )
  # Predicted probabilities
  nn_predicted_prob <- predict(nn_model,
                                wdbc_test,
                                type = "prob"
  )
  return(
    list(
      wdbc_test = wdbc_test,
      nn_predicted_class = nn_predicted_class,
      nn_predicted_prob = nn_predicted_prob
    )
  )
}
