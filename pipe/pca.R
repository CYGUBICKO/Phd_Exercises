library(ggplot2)
theme_set(theme_bw())
library(dplyr)

## Steve: One of the requirement of a PCA dataset is that it should be scaled. 

## Jonathan: This is the kind of statement to avoid: 
## If scale is an option, that implies that we don't always need it
## If you feel you need to understand scaling, try to work it out
## Otherwise, leave it for later
## Don't pretend

## Diagnosis is the first column of wdbc
pca_result <- prcomp(wdbc[-1], center = TRUE, scale = TRUE)
biplot(pca_result, scale = 0)

pca_var <- (pca_result$sdev)^2
prop_var_exp <- pca_var/sum(pca_var)
plot(prop_var_exp, xlab = "Principal Component",
	ylab = "Proportion of Variance Explained",
	type = "b"
)

pca_df <- pca_result$x %>% data.frame()
summary(pca_df)

## Does the labs line do anything?
print(ggplot(pca_df, aes(x=PC1, y=PC2, col=wdbc$diagnosis)) 
	+ geom_point(alpha=0.5) 
	## + labs(color = "Diagnosis")
)
