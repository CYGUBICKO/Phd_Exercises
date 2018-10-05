library(corrplot)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())

# Load available auc objects from the fitted models
l <- ls()
auc_list <- list()
prop_mal_list <- list()
auc_obj <- grep("auc_result", l, value = TRUE)
prop_mal_obj <- grep("malignant_result", l, value = TRUE)
for (i in 1:length(auc_obj)){
	auc_list[[auc_obj[[i]]]] <- get(auc_obj[[i]])
	prop_mal_list[[prop_mal_obj[[i]]]] <- get(prop_mal_obj[[i]])
}

# Correlation between estimates across partitions
auc_df <- as.data.frame(auc_list)
names(auc_df) <- gsub("*_auc\\w+", "", names(auc_df))
corr <- cor(auc_df, method = "spearman")
corrplot(corr, method="number", bg = "gray88")
# Create the partition set variable
auc_df <- auc_df %>% 
	mutate(partition_set = paste("set", 1:n())) %>%
	gather(model, auc_value, -partition_set)

print(
	ggplot(data=auc_df, 
		aes(x=model, y=auc_value, colour=model)
	) 
	+ geom_boxplot()
	+ ylab("AUC")
	## + ggtitle("AUC scores across various sets of data partitions")
)

