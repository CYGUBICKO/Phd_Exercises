library(dplyr)
library(polyreg)
library(scales)

seed

# This script fits polynomial of degree to our data

train_df <- (train_df 
	%>% mutate(diagnosis = as.character(diagnosis))
	%>% select(31:1) # Reorder the variables - polyreg
)

test_df <- (test_df 
	%>% mutate(diagnosis = as.character(diagnosis))
	%>% select(31:1) 
)

# Cross validation to pick optimal no. of degrees
poly_cv <- xvalPoly(train_df
	, maxDeg=3
	, use="glm"
)

print(poly_cv)

# Fit the polynomial
poly_model <- polyFit(train_df
	, deg = which.max(poly_cv)
	, use = "glm"
)

# Predict
poly_pred <- predict(poly_model, test_df[, -31])

# Proportion of correct predictions - Polyreg
poly_pcp <- data.frame(model = "poly"
	, pcp = mean(poly_pred == test_df$diagnosis)
)

# Proportion of correct prediction - NN
caret_pcp <- (obs_pred_df1 
	%>% group_by(model) 
	%>% summarise(pcp = mean(pred==obs))
)

# Everything together
pcp_tab <- (bind_rows(caret_pcp, poly_pcp)
	%>% arrange(-pcp)
	%>% mutate(pcp = percent(pcp))
)
pcp_tab

