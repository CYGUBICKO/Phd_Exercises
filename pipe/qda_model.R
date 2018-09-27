library(caret)
library(MASS)

# Fit QDA model to our training and test on the test data
qdaModel <- function(seed, part_ratio){
  wdbc_part <- dataPartition(seed, part_ratio)
  wdbc_train <- wdbc_part$wdbc_train
  wdbc_test <- wdbc_part$wdbc_test
  qda_model <- train(diagnosis~.,
                     wdbc_train,
                     method = "qda",
                     metric = "ROC",
                     preProc = c("center", "scale"),
                     tuneLength = 10,
                     trControl = model_control
  )
  # Predictions
  ## We predict the classes on test data
  qda_predicted_class <- predict(qda_model,
                                 wdbc_test
  )
  # Predicted probabilities
  qda_predicted_prob <- predict(qda_model,
                                wdbc_test, 
                                type = "prob"
  )
  return(
    list(
      wdbc_test = wdbc_test,
      qda_predicted_class = qda_predicted_class,
      qda_predicted_prob = qda_predicted_prob
    )
  )
}
