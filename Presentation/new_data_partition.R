library(dplyr)

# Training data
x_train <- (train_dfN
	%>% select(-diagnosisN)
)
y_train <- train_dfN$diagnosisN

# Test data
x_test <- (test_dfN
	%>% select(-diagnosisN)
)
y_test <- test_dfN$diagnosisN
