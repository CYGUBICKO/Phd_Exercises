library(ROCR)

# Bootstrap auc estimates and then compute 2.5% and 97.5% quantiles

df_pred <- data.frame(
	probs = nnet_test$probs
	, response = y_test
)
boot_auc <- aucBoot(df_pred, 2000)
knitr::kable(boot_auc$estimates)
