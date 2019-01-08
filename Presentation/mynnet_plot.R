library(ROCR)
library(ggplot2)

# Extract auc and plot ROC

y_test <- ifelse(y_test==1, "M", "B")

rocr_pred <- prediction(nnet_test$probs
	, y_test
)

rocr_est <- performance(rocr_pred
	, "tpr"
  	, "fpr"
)

rocr_df <- data.frame(x = rocr_est@x.values[[1]]
	, y = rocr_est@y.values[[1]]
)

print(
	ggplot(rocr_df, aes(x = x, y = y))
   + geom_line(aes(colour = "blue"))
   + coord_cartesian(xlim = c(0, 0.2), ylim = c(0.8, 1)) 
   + guides(colour=FALSE)
   + labs(title = "ROC Curve"
   	, x = "False positive rate"
      , y = "True positive rate"
  	)
)




