library(tidyr)
library(dplyr)

# This script scales and structure data into appropriate neuranet package format.

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

# Create model formula

modelForm <- as.formula(
	paste("diagnosisN ~ "
		, paste(names(train_dfN)[!names(train_dfN) %in% c("diagnosisN")]
		, collapse = "+"
		)
	)
)



