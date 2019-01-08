# Test performance of the NN on new testing data

nnet_test <- predictNnet(nnet_out, x_test)

# Test error
round(1 - mean(nnet_test$class==y_test), digits = 5)
