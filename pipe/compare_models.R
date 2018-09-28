library(ROCR)

## Pull predicted values for the models to compare

# lda
lda_pred_roc <- prediction(lda_pred$posterior[,2], wdbc$diagnosis)
lda_pred_per <- performance(lda_pred_roc, "tpr", "fpr")
lda_auc <- performance(lda_pred_roc, "auc")

# qda
qda_pred_roc <- prediction(qda_pred$posterior[,2], wdbc$diagnosis)
qda_pred_per <- performance(qda_pred_roc, "tpr", "fpr")
qda_auc <- performance(qda_pred_roc, "auc")

# Print out the auc
auc_tab <- data.frame(lda_auc = lda_auc@y.values, 
	qda_auc = qda_auc@y.values
	)
colnames(auc_tab) <- c("lda_auc", "qda_auc")
auc_tab

## We should work on being more tidy, e.g., can this be a ggplot?
## In the meantime, I made colors that I can see clearly
## and blew things up … need to fix the legend (unless we tidy)
## Don't use png or pdf commands unless you need to; this can be handled 
## automatically by the make pipeline (I'll show you)

# Save ROC curve
plot(lda_pred_per, main = "ROC"
	, col = 2
	, xlim = c(0, 0.1)
	, ylim = c(0.9, 1)
)
plot(qda_pred_per, main = "ROC", col = 4, add = TRUE)
legend(0.6, 0.6, c("LDA", "QDA"), c(2, 4))
