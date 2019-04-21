library(dplyr)
library(ggplot2)

theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

predicted_class_plot <- (obs_pred_df 
	%>% filter(Observation=="pred")
	%>% ggplot(aes(x = model, fill = Diagnosis)) 
		+ geom_bar(stat="count", alpha = 0.4)
		+ geom_hline(yintercept = obs_count[[1]]
			, linetype = "dashed"
			, size = 1
		)
		+ labs(y = "Observed Count"
			, x = "Model"
		)
		+ theme(legend.position="bottom")
)
predicted_class_plot
