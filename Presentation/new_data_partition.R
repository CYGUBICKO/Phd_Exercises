library(tidyr)
library(dplyr)

## Training data

# Scale data
train_dfN <- (train_df
   %>% mutate_at(
      funs(as.numeric(scale(.)))
   , .vars = vars(-diagnosis)
   )
   %>% mutate(
      diagnosisN = ifelse(diagnosis=="M", 1, 0)
   )
   %>% select(-diagnosis)
)

# Select independent and dependent variables
x_train <- (train_dfN
	%>% select(-diagnosisN)
)
y_train <- train_dfN$diagnosisN

# Test data
test_dfN <- (test_df
   %>% mutate_at(
      funs(as.numeric(scale(.)))
   , .vars = vars(-diagnosis)
   )
   %>% mutate(
      diagnosisN = ifelse(diagnosis=="M", 1, 0)
   )
   %>% select(-diagnosis)
)


x_test <- (test_dfN
	%>% select(-diagnosisN)
)
y_test <- test_dfN$diagnosisN
