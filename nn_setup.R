library(neuralnet)
library(ggplot2)
set.seed(237)

# Model setup
## We have transformed our outcome variable diagnosis to binary class where M=1
## We will perform classification and return the probability of being in M.
## Another implementation would be to use a multiclass aproach
## We will allow neuralnet to perform random guess of the initial weights
## err.fct = "ce", can be used for binary classification but the best implementation
## is through multiclass implementation
## Also start with hidden layers of 3

# Binary classification

error <- NULL # This the cross-entropy error
h_layers <- NULL
for (i in 1:10){
	nn_modelN <- neuralnet(modelForm1
		, data = train_dfN
		, linear.output = FALSE
		, err.fct = "ce"
		, hidden = i
		)
	plot(nn_modelN, rep = "best", main = paste(i, " Hidden layers"))
	error[[i]] <- nn_modelN$result.matrix[1,1]
	h_layers[[i]] <- i
}

## Errors versus number of hidden layers
error_df <- data.frame(h_layers = h_layers
	, error = error
	)

print(
	ggplot(error_df,
		aes(x = h_layers, y = error)
		)
		+ geom_line(colour = "blue")
		+ labs(title = "Variation of cross-entropy error with number of hidden layers"
			, x = "# of hidden layers"
			, y = "Cross-entropy error"
			)
)

# Multiclass implementation
error2 <- NULL
h_layers2 <- NULL
for (i in 1:10){
nn_modelN2 <- neuralnet(modelForm2
	, data = train_dfN
	, linear.output = FALSE
	, hidden = c(i, 3)
	)
	error2[[i]] <- nn_modelN2$result.matrix[1,1]
	h_layers2[[i]] <-i
	plot(nn_modelN2, rep = "best", dimension = 10, main = paste(i, " Hidden layers"))
}

error_df2 <- data.frame(h_layers = h_layers2
	, error = error2
	)

print(
	ggplot(error_df2,
		aes(x = h_layers, y = error)
		)
		+ geom_line(colour = "blue")
		+ labs(title = "Variation of cross-entropy error with number of hidden layers"
			, x = "# of hidden layers"
			, y = "Cross-entropy error"
			)
)



