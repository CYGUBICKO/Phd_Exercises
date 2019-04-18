library(nnet)
library(tidyr)
library(dplyr)
library(tibble)
library(xtable)

## Organise test summary stats
test_measures_df <- (test_measures_df
	%>% arrange(desc(AUC))
)
test_measures_df
test_measures_df <- xtable(test_measures_df, digits = 4)
test_measures_df_tex <- print(test_measures_df
	, file = "test_measures_df.tex" 
	, sanitize.text.function = function(x){x}
	, sanitize.colnames.function=bold
	, only.contents = TRUE
	, include.rownames = FALSE
	, timestamp = NULL
)

# Best performing model per metric
metric_df <- (test_measures_df
	%>% column_to_rownames("Model")
)
metric_max <- apply(metric_df, 2, which.is.max)
best_metric <- tibble(Metric = c(names(metric_max), rep(NA, 5))
	, "Best model" = c(rownames(metric_df)[metric_max], rep(NA, 5))
	, Score = c(mapply(function(x,y) {metric_df[x, y]}
		, metric_max
		, names(metric_max)
	)
		, rep(NA,5)
	)
)
best_metric
best_metric <- xtable(best_metric, digits = 4)
best_metric_tex <- print(best_metric
	, file = "best_metric.tex" 
	, sanitize.text.function = function(x){x}
	, sanitize.colnames.function=bold
	, only.contents = TRUE
	, include.rownames = FALSE
	, timestamp = NULL
)

