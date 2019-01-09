library(dplyr)
library(pROC)
library(tibble)
library(ggplot2)
set.seed(237)

## This script computes the CI for AUC using

# Extract predicted probabilities and observed classes
extPreds <- function(df){
	df <- (df
		%>% mutate(probs = M, diagnosis = obs_diag)
		%>% select(probs, diagnosis)
	)
}

pred_df <- lapply(prob_pred_df1, extPreds)

# Function to compute CI

aucCi <- function(df){
	roc_obj <- roc(df[,"diagnosis"]
		, df[, "probs"]
      , levels = c("M", "B")
	)
  auc_ci <- ci(roc_obj)
  as.vector(auc_ci)
}

pred_ci <- lapply(pred_df, aucCi)
pred_ci <- do.call("rbind", pred_ci)
colnames(pred_ci) <- c("Lower", "AUC", "Upper")

pred_ci <- (pred_ci 
	%>% as.data.frame()
	%>% rownames_to_column()
)

print(
  ggplot(pred_ci, aes(x = reorder(rowname, -AUC), y = AUC))
  + geom_point(size = 4)
  + geom_errorbar(aes(ymin = Lower, ymax = Upper))
  + labs(x = "Model"
  ,	y = "CI"
  ,	title = "Compare CI of the models"
  )
)
