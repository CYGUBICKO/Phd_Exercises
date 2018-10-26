
library(ggplot2)
library(MASS)
library(dplyr)

lda_result <- lda(diagnosis~., data = wdbc, center=T, scale = T)

print(lda_result$prior)
print(lda_result$svd)

lda_pred <- predict(lda_result, wdbc)
lda_pred_df <- lda_pred$x %>% as.data.frame()
lda_pred_df <- cbind(lda_pred_df, diagnosis=wdbc[, "diagnosis"])

print(ggplot(lda_pred_df, aes(x=LD1, fill=diagnosis)) 
	+ geom_density(alpha=0.5)
)

