library(ggplot2)
library(dplyr)

theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Wrapper to hold auc plot to report
auc_df2 <- (auc_df
	%>% group_by(Model)
	%>% mutate(medians = median(AUC))
	%>% ungroup()
)
print(
	ggplot(auc_df2
		, aes(x = reorder(Model, -medians), y = AUC)
		)
		+ geom_boxplot(outlier.colour=NULL, fill = "gray")
#		+ scale_colour_brewer(palette="Set1")
		+ labs(x = "Model"
			, y = "AUC"
		)
)

