library(data.table)
library(dplyr)
library(tibble)
library(caret)
library(gbm)
library(ggplot2)
theme_set(theme_bw() + 
	theme(panel.spacing=grid::unit(0,"lines")))

# Compute variable (relative) importance for all the models

topn <- 10
varimp_lst <- list()

for (i in 1:n_models){
	set.seed(257)
	model <- gsub("_fit", "", names(fitted_models)[[i]])
	if (grepl("RF|NN", names(fitted_models)[[i]])){
		varimp <- varImp(fitted_models[[i]], useModel = FALSE)
	} else{
		varimp <- varImp(fitted_models[[i]])
	}
	varimp_lst[[model]] <- (varimp[["importance"]]
		%>% data.frame()
		%>% rownames_to_column("var")
		%>% select(1:2)
		%>% setnames(names(.), c("Predictors", "Importance"))
		%>% arrange(desc(Importance))
		%>% rowid_to_column("Score")
		%>% filter(Score <= topn)
		%>% mutate(Model = model)
	)
}
varimp_df <- (Reduce(rbind, varimp_lst)
	%>% select(-Score)
	%>% data.frame()
	%>% rowid_to_column("Score")
)
varimp_df

(ggplot(varimp_df, aes(x = Score, y = Importance, colour = "blue", group = 1))
	+ geom_point()
	+ geom_segment(aes(x = Score, xend = Score, y = 0, yend = Importance))
	+ scale_fill_manual(values = "blue")
	+ guides(colour = FALSE)
	+ facet_wrap(Model~., scale = "free")
	  # Add categories to axis
	+ scale_x_continuous(breaks = varimp_df$Score
		, labels = varimp_df$Predictors
#		, expand = c(0,0)
	)
	+ labs(x = "Predictors")
	+ coord_flip()
)

