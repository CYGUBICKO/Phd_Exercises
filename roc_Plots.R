library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

set.seed(257)
# Wrapper to hold roc plot to report

roc_plot <- (
	ggplot(roc_df, aes(x = x, y = y, group = model, colour = model))
	+ geom_line(aes(lty = model))
	+ scale_x_continuous(limits = c(0, 0.5))
	+ scale_y_continuous(limits = c(0.75, 1))
	+ scale_colour_brewer(palette="Set1")
#	+ scale_colour_brewer(palette="BrBG")
	+ labs(x = "False positive rate"
		, y = "True positive rate"
		, colour = "Model"
		, lty = "Model"
	)
)
roc_plot

