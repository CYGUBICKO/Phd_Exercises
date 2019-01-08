nnet_out <- trainMynnet(x_train
	, y_train
	, hidden = hidden
	, learn_rate = learn_rate
	, lambda = lambda
	, iters = iters
)

# Training error
yhat <- ifelse(nnet_out$yhat>=0.5, 1, 0)
round(1 - mean(y_train==yhat), digits = 5)

