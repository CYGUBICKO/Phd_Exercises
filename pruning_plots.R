library(caret)
library(dplyr)
library(purrr)
library(ggplot2)
library(lattice)

theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))
trellis.par.set(caretTheme())

best_tune <- list()
tune_lst <- list()
figures <- list()
roc_density <- list()
for (i in 1:length(fitted_models)){
	set.seed(237)
	b_tune <- fitted_models[[i]]$bestTune
	rownames(b_tune) <- NULL
	best_tune[[names(fitted_models)[i]]] <- b_tune
	tune_lst[[names(fitted_models)[i]]] <- fitted_models[[i]]$results
	tryCatch(
		figures[[names(fitted_models)[i]]] <- (
			ggplot(fitted_models[[i]]) #, main = names(fitted_models)[i]) 
			#	+ scale_colour_brewer(palette="Dark2") 
		)

		, roc_density[[names(fitted_models)[i]]] <- densityplot(fitted_models[[i]]
			, pch = "|", resamples = "all")
		, error = function(e){print(e)}
	)
}

# Show plots
figures

# Best tuned models
best_tune

# Print out the pruning summary 
tune_lst

# Comparing Resampling Distributions
roc_density

