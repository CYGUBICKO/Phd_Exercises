backprop <- function(x, y, yhat, w1, w2, learn_rate, lambda, H1, H2, a1){
	n <- dim(x)[1]
	delta <- -(y - yhat) * sigmoidPrime(H2)
	dJdW2 <- (t(cbind(1, a1)) %*% delta)/n + lambda * w2
	delta2 <- delta %*% t(w2[-1, drop = FALSE]) * sigmoidPrime(H1)
	dJdW1 <- (t(cbind(1, x)) %*% delta2)/n + lambda * w1

	w1 <- w1 - learn_rate * dJdW1
	w2 <- w2 - learn_rate * dJdW2
	
	return(
		list(w1 = w1
			, w2 = w2
		)
	)
}
