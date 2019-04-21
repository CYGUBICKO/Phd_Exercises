library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

predicted_prob_plot <- (
	ggplot(prob_pred_df)
	+ geom_density(aes(x = round(prob, 2), y = ..scaled.., fill = factor(obs_diag), group = factor(obs_diag))
		, alpha = 0.4
		, n = 40
		)
	+ facet_wrap(~model, scales = "free")
	+ labs(x = "Probabilities"
		, fill = "Observed Diagnosis"
	)
	+ theme(legend.position="bottom")
)
predicted_prob_plot


