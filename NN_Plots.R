library(caret)

library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Summarize NN model

nn_model <- fitted_models[["NN_fit"]]
nn_best <- nn_model$bestTune
nn_best
nn_cv_plot <- (ggplot(nn_model$results, aes(x = size, y = ROC, group = as.factor(decay), colour = as.factor(round(decay, 5))))
	+ geom_line()
	+ geom_point()
	+ scale_colour_brewer(palette="BrBG")
	+ labs(x = "# Hidden Units"
		, y = "AUC (Cross-Validation)"
		, colour = "Weight Decay"
	)
	+ geom_label(aes(x = 10
		, y = 0.98
		, label = paste0("Best tune: size = ", nn_best$size, " and decay = ", round(nn_best$decay, 5)))
		#, vjust = -0.4
		, fontface = 1
		, inherit.aes = FALSE
	)
)
print(nn_cv_plot)
#ggsave("nn_cv_plot.pdf", nn_cv_plot)
