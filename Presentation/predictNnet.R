predictNnet <- function(object, newdata){
	est <- feedforward(newdata
			, w1 = object$w1
			, w2 = object$w2
		)
	list(
		probs = est$yhat
		, class = ifelse(est$yhat>=0.5 , 1, 0) 
	)
}



