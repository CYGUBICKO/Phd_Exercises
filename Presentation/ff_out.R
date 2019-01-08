# Implement forward propagation

ff_out <- feedforward(x_train
	, w1
	, w2
)

# Training error
yhat <- ifelse(ff_out$yhat>=0.5, 1, 0)
1 - mean(y_train==yhat)
