library(corrplot)
library(dplyr)
library(tidyr)
library(ggplot2)

# This script loads available auc objects from the fitted models and summarize/plot them

l <- ls()
auc_list <- list()
prop_malignant_list <- list()
auc_objects <- grep("auc_result", l, value = T)
prop_malignant_objects <- grep("malignant_result", l, value = T)
for (i in 1:length(auc_objects)){
	auc_list[[auc_objects[i]]] <- get(auc_objects[i])
	prop_malignant_list[[prop_malignant_objects[i]]] <- get(prop_malignant_objects[i])
}

## AUC
# Correlation between estimates
auc_df <- as.data.frame(auc_list)
new_var_names <- gsub("*_auc\\w+", "", names(auc_df))
names(auc_df) <- new_var_names
corr <- cor(auc_df, method = "spearman")
corrplot(corr, method="number", bg = "gray88")
# Create the partition set variable
auc_df <- auc_df %>% 
	mutate(partition_set = paste("set", 1:n())) %>%
	gather(model, auc_value, -partition_set)

ggplot(data=auc_df, aes(x=partition_set, y=auc_value, group=model, colour=model)) +
    geom_line() + 
	 geom_point() + 
	 xlab("Partition sets") + ylab("AUC") + 
	 ggtitle("AUC scores across various sets of data partitions")

## Proportion of predicted Malignant 
# Correlation between estimates
prop_malignant_df <- as.data.frame(prop_malignant_list)
names(prop_malignant_df) <- new_var_names
corr <- cor(prop_malignant_df, method = "spearman")
corrplot(corr, method="number", bg = "gray88")
# Create the partition set variable
prop_malignant_df <- prop_malignant_df %>% 
	mutate(partition_set = paste("set", 1:n())) %>%
	gather(model, prop_malignant_value, -partition_set)

ggplot(data=prop_malignant_df, aes(x=partition_set, y=prop_malignant_value, group=model, colour=model)) +
    geom_line() + 
	 geom_point() + 
	 xlab("Partition sets") + ylab("Proportion of Predicted Malignant") + 
	 ggtitle("Malignant proportions across various sets of data partitions")
