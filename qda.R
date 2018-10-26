library(ggplot2)
library(MASS)
library(dplyr)

qda_result <- qda(diagnosis~., data = wdbc)

print(qda_result$prior)

qda_pred <- predict(qda_result, wdbc)

