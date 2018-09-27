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

# Save ROC curve
png("compare_models.png")
plot(lda_pred_per, main = "ROC", col = 2)
plot(qda_pred_per, main = "ROC", col = 3, add = TRUE)
legend(0.6, 0.6, c("LDA", "QDA"), 2:3)
dev.off()
