library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Wrapper to hold auc plot to report

print(
	ggplot(auc_df
		, aes(x = reorder(Model, -AUC), y = AUC)
		)
		+ geom_boxplot(outlier.colour=NULL)
		+ scale_colour_brewer(palette="Set1")
		+ labs(x = "Model"
			, y = "AUC"
		)
)

