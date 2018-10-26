library(dplyr)
library(purrr)

prune_lst <- list()
for (i in 1:length(fitted_models)){
	prune_lst[[names(fitted_models)[i]]] <- fitted_models[[i]]$results
	tryCatch(
		print(
			plot(fitted_models[[i]], main = names(fitted_models)[i], cex.main = 0.7)
		)
		, error = function(e){print(e)}
	)
}

# Print out the pruning summary 
prune_lst
