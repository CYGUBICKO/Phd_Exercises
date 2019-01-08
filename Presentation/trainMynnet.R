trainMynnet <- function(x, y, hidden = 10, learn_rate = 1e-2, lambda = 1e-2, iters = 1e4){
	x <- as.matrix.data.frame(x)
	hidden <- hidden
	n_xvars <- ncol(x) + 1 # + bias term 
	w1 <- matrix(rnorm(n_xvars * hidden), n_xvars, hidden)
	w2 <- as.matrix(rnorm(hidden + 1))
	for (iter in 1:iters){
		fprop <- feedforward(x, w1, w2)
		bprop <- backprop(x
			, y
			, yhat = fprop$yhat
			, w1
			, w2
			, lambda = lambda
			, learn_rate = learn_rate
			, H1 = fprop$H1
			, H2 = fprop$H2
			, a1 = fprop$a1
		)
		w1 <- bprop$w1
		w2 <- bprop$w2
	}
	return(
		list(yhat = fprop$yhat
			, w1 = w1
			, w2 = w2
		)
	)
}
