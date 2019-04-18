library(caret)

library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Summarize RF model

rf_model <- fitted_models[["RF_fit"]]
rf_best <- rf_model$bestTune
rf_cv_plot <- (ggplot(rf_model)
	+ labs(y = "AUC (Cross-Validation)")
	+ geom_label(aes(x = 15
		, y = 0.9935
		, label = paste0("Best tune: No. predictors = ", rf_best$mtry, ", \nSplitrule = ", rf_best$splitrule, " and Min. node size = ", rf_best$min.node.size))
	#, vjust = -0.4
#	, size = 5
	, fontface = 1
	, inherit.aes = FALSE
	)
)
print(rf_cv_plot)

#ggsave("rf_cv_plot.pdf", rf_cv_plot)

