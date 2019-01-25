library(dplyr)
library(tidyr)
library(neuralnet)
library(ggplot2)
library(ROCR)
set.seed(237)

# Model setup
## We have transformed our outcome variable diagnosis to binary class where M=1
## We will perform classification and return the probability of being in M.
## Another implementation would be to use a multiclass aproach
## We will allow neuralnet to perform random guess of the initial weights
## err.fct = "ce", can be used for binary classification but the best implementation
## is through multiclass implementation

# Binary classification



nnFunc <- function(layers){
	error <- numeric(length(layers)) 
	h_layers <-  numeric(length(layers))
	nn_train_aucN <- NULL
	nn_test_aucN <- NULL
	h_length <- NULL
	for (i in 1:length(layers)){
		test_df <- test_dfN
		train_df <- train_dfN
		name_id <- paste("hidden", i, sep = "")
		nn_modelN <- neuralnet(modelForm
			, data = train_df
			, linear.output = FALSE
			, err.fct = "ce"
			, hidden = layers[[i]] 
		)
		# Plot the neural networks
		plot(nn_modelN, rep = "best", main = paste(i, "Hidden neurons"))
		# Cross-entropy error
		error[[i]] <- nn_modelN$result.matrix[1,1]

		h_layers[[i]] <- paste(layers[[i]], collapse = ",")  
		h_length[[i]] <- length(layers[[i]])

		# Training performance
		## Set up for AUC
		train_df$prob <- nn_modelN$net.result[[1]] 
		## Performance on the training data
		nn_train_pred <- prediction(train_df$prob, train_df$diagnosisN)
		nn_train_perf <- performance(nn_train_pred, "auc")
		nn_train_aucN[[i]] <- nn_train_perf@y.values[[1]]
	
		# Test performance
		## Prediction on the test data
		nn_computed <- compute(nn_modelN, test_df[, c(1:30)], rep = 1)
		## Assign probabilities to the test sample
		test_df$prob <-nn_computed$net.result 
		## Performance on the test data
		nn_test_pred <- prediction(test_df$prob, test_df$diagnosisN)
		nn_test_perf <- performance(nn_test_pred, "auc")
		nn_test_aucN[[i]] <- nn_test_perf@y.values[[1]]
	}

	perf_df <- (data.frame(n = h_layers
		, auc_train = nn_train_aucN
		, auc_test = nn_test_aucN
		, h_length = h_length
		)
		%>% gather(Sample, score, -n, -h_length)
		%>% mutate(Sample = gsub("auc_", "", Sample))
	)

	error_df <- data.frame(n = h_layers
		, error = error
		, h_length = h_length
	)
	return(nn_resultN = list(
		error_df = error_df
		, perf_df = perf_df
		)
	)
}

# Generate the combination of hidden layers and neurons. The input is the maximum number of hidden layers. The function will computes neuron-hidden layers combination

layersFunc <- function(n){
	x <- 1:n
	p <- n
	layer_lst <- list()
	for (i in 1:n){
		if (i==1){
			for (j in 1:n){
				layer_lst[[j]] <- x[j]
			}
		}
		else{
			for(j in 1:(n-i+1)){
				for (k in (j+i-1):n){
					p <- p + 1
					layer_lst[[p]] <- c(x[j:(j+i-2)], x[k])
				}
			}
		}
	}
	return(layers = layer_lst)
}

## Layers input of the function is the number of hidden layers
n <-1 
layers <- layersFunc(n)
nn_resultN <- nnFunc(layers) 

# Compare Test and train AUC
perf_df <- nn_resultN$perf_df
#perf_df$n <- factor(perf_df$n, levels = levels(perf_df$n)[order(perf_df$h_length)])
print(
	ggplot(perf_df, 
	aes(x = reorder(n, h_length)
	, y = score
	, colour = Sample
	, group = Sample)
	)
	+ geom_line()
	+ geom_point()
	+ labs(title = "Test-Train AUC given  x # of neurons in some hidden layer"
		, x = "# Neuron in each hidden layer"
		, y = "AUC"
		)
)


## Errors versus number of hidden layers
error_df <- nn_resultN$error_df
print(
	ggplot(error_df,
		aes(x = reorder(n, h_length), y = error, group = 1)
		)
		+ geom_line(colour = "blue")
		+ geom_point()
		+ labs(title = "Variation of cross-entropy error given x # of neurons in some hidden layer"
			, x = "# Neuron in each hidden layer"
			, y = "Cross-entropy error"
			)
)
