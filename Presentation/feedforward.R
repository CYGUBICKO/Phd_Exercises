feedforward <- function(x, w1, w2){
  	x <- as.matrix.data.frame(x)
	H1 <- cbind(1, x) %*% w1
  	a1 <- sigmoid(H1)
  	H2 <- cbind(1, a1) %*% w2
  	a2 <- sigmoid(H2)
  	return(
		list(yhat = a2
			, H1 = H1
			, H2 = H2
			, a1 = a1
		)
	)
}
