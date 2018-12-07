library(dplyr)
library(purrr)

best_tune <- list()
tune_lst <- list()
for (i in 1:length(fitted_models)){
	seed
	b_tune <- fitted_models[[i]]$bestTune
	rownames(b_tune) <- NULL
	best_tune[[names(fitted_models)[i]]] <- b_tune
	tune_lst[[names(fitted_models)[i]]] <- fitted_models[[i]]$results
	tryCatch(
		print(
			plot(fitted_models[[i]], main = names(fitted_models)[i], cex.main = 0.7)
		)
		, error = function(e){print(e)}
	)
}

# Best tuned models
best_tune

# Print out the pruning summary 
tune_lst
