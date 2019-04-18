library(caret)

library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Summarize KNN model

knn_model <- fitted_models[["KNN_fit"]]
knn_best <- knn_model$bestTune
knn_best
knn_cv_plot <- (ggplot(knn_model)
	+ labs(y = "AUC (Cross-Validation)")
	+ geom_label(aes(x = 10
		, y = 0.9935
		, label = paste0("Best tune: k = ", knn_best$k))
	#, vjust = -0.4
#	, size = 5
	, fontface = 1
	, inherit.aes = FALSE
	)
)
print(knn_cv_plot)
#ggsave("knn_cv_plot.pdf", knn_cv_plot)

