feedfoward <- function(x, w1, w2){
  x <- as.matrix.data.frame(x)
  H2 <- cbind(1, x) %*% w1
  a2 <- sigmoid(H2)
  H3 <- cbind(1, H2) %*% w2
  a3 <- sigmoid(H3)
  return(yhat = a3)
}
