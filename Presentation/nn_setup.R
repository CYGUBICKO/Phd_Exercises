
# Setup parameters for training
hidden <- 10
learn_rate <- 1e-2
lambda <- 1e-2
iters <- 1e4

# Since we are also testing each step, set up for initial weights

n_ind_vars <- ncol(x_train) + 1

# Initial weights to the hidden layer
w1 <- matrix(
	rnorm(n_ind_vars * hidden)
		, n_ind_vars
    	, hidden
	)

# Initial weights to the output layer
w2 <- as.matrix(rnorm(hidden + 1))
w1


