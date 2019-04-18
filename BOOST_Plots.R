library(caret)

library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Summarize Boosting model

boost_model <- fitted_models[["BOOST_fit"]]
boost_best <- boost_model$bestTune
boost_best
boost_cv_plot <- (ggplot(boost_model$results, aes(x = n.trees, y = ROC, group = as.factor(interaction.depth)))
	+ geom_line(aes(colour = as.factor(interaction.depth)))
	+ geom_point(aes(colour = as.factor(interaction.depth)))
	+ scale_colour_brewer(palette="BrBG")
	+ labs(x = "# of trees"
		, y = "AUC (Cross-Validation)"
		, colour = "Max Tree Depth"
	)
	+ geom_label(aes(x = 300
		, y = 0.9935
		, label = paste0("Best tune: n.trees = ", boost_best$n.trees, ", Depth = ", boost_best$interaction.depth, ", \nShrinkage = ", boost_best$shrinkage))
		#, vjust = -0.4
		, fontface = 1
		, inherit.aes = FALSE
	)
)
print(boost_cv_plot)
#ggsave("boost_cv_plot.pdf", boost_cv_plot)
