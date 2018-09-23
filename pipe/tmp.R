

#### Correlation

The next step invloves checking the correlation between the features. This will help us reduce the number of features based on the strength of association. In addition, training a model on a data set with features which have little or no correlation may lead to inaccurate results. It is therefore important to identify and filter out features which are not correlated to other features, more so if measuring the similar aspects, [Yu, Lei and Liu, Huan](http://www.aaai.org/Papers/ICML/2003/ICML03-111.pdf).


```{r, echo=T}
features_df <- wdbc[, ind_vars]
cor_mat <- cor(features_df)
corrplot(cor_mat, order = "hclust", tl.cex = 1, addrect = 8)
```


## Model Fitting


### Principal Component Analysis and Linear Discriminant Analysis

Since there are many correlated features, we will use PCA to reduce the dimension of the data. Both LDA and PCA are used to classify and reduce the dimentionality of the data. One of the key difference is that PCA is unsupervised learning while LDA is supervised. 


#### PCA



### Machine Learning Models

Machine learning is a science which involves the application of Artificial Intelligence (AI) that enables the computers to automatically learn and improve or get things done based on experience without being explicitly programed. This involves computer looking for patterns based on previous observations, experiences or instructions. ML algorithms are broadly classified as supervised, unsupervised and reinforcement learning. In this exercise, we will fit some of the supervised learning algorithms:

* LDA
* Neural Networks
* K - Nearest Neighbors (KNN)
* Random Forest
* Naive Bayes
* Support Vector Machine (SVM)

We then further, to some models, incorporate either PCA or LDA to assess if there could be any improvement in model performance.

#### Dataset Partitioning 

We need to assess the model quality after model fitting. Datset partitioning helps us split the datset into training (used for model fitting) and test (used for model validation) datasets. In the present case, we split the datset into  $80$% of which we will use to train our models and $20$% that we will hold back as a validation dataset.


```{r, echo=T}
set.seed(1000)
df_index <- createDataPartition(wdbc$diagnosis, p=0.7, list = F)
train_df <- wdbc[df_index, -1]
test_df <- wdbc[-df_index, -1]
```


Data \textbf{pre-processing} involves transforming data into a specific format to improve the performance of machine learning algorithms. We'll use \textbf{preProcess} function in package \textit{caret} to transform the data.

Our main focus is transforming our predictors (characteristics) such that we reduce their dimensionality to fewer dimension where the new characterisitcs are uncorrelated. Therefore, we'll apply \textit{pca} method with a threshold of $.99$.


```{r, echo=T}
model_control <- trainControl(method="cv",
                            number = 5,
                            preProcOptions = list(thresh = 0.99),
                            classProbs = TRUE,
                            summaryFunction = twoClassSummary)
```


#### LDA

Define training and testing data sets for LDA models.


```{r, echo=T}
train_lda_df <- lda_result_df[df_index,]
test_lda_df <- lda_result_df[-df_index,]
```


```{r, echo=T}
lda_model <- train(diagnosis~., train_lda_df,  method="lda2",  metric="ROC",
                   preProc = c("center", "scale"),
                   tuneLength = 10,
                   trControl=model_control)
```




Using \textit{predict} function, we generate the clasiffication and posterior probabilities based on the LDA model.

```{r, echo=T}
lda_predicted <- predict(lda_model, test_lda_df)
knitr::kable(as.data.frame(table(lda_predicted)))
```

We can summarize the performance of the LDA classification  using $\textit{Confusion Matrix}$.

```{r, echo=T}
lda_confusion_mat <- confusionMatrix(lda_predicted, test_lda_df$diagnosis, positive = "M")
knitr::kable(lda_confusion_mat$table)
```


The overall accuracy of our model is `r round(lda_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(lda_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(lda_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
lda_predicted_prob <- predict(lda_model, test_lda_df, type="prob")
#colAUC(lda_predicted_prob, test_lda_df$diagnosis, plotROC=TRUE)
```

#### Neural Networks

Our second ML algorithm applied to the data is Neural Networks. A neural network model can be though of as a model consisting of an activation function. The activation function transforms inputto output through information processing unit. For this and other reasons, neural networks is considered complex and mostly oftenly regarded as a 'black box'.

```{r, echo=T}
nn_model <- train(diagnosis~.,
                    train_df,
                    method="nnet",
                    metric="ROC",
                    preProcess=c('center', 'scale'),
                    trace=FALSE,
                    tuneLength=10,
                    trControl=model_control)
```


Predicted values for Neural Network model.

```{r}
nn_predicted <- predict(nn_model, test_df)
knitr::kable(as.data.frame(table(nn_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
nn_confusion_mat <- confusionMatrix(nn_predicted, test_df$diagnosis, positive = "M")
knitr::kable(nn_confusion_mat$table)
```




The overall accuracy of our model is `r round(nn_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(nn_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(nn_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
nn_predicted_prob <- predict(nn_model, test_df, type="prob")
#colAUC(nn_predicted_prob, test_df$diagnosis, plotROC=TRUE)
```


#### K-nearest Neighbors (KNN)

KNN is a ML algorithm widely used in classification problems. The algorithm goes through the datset to find the k-nearest case and classifies new cases by a majority vote of its k neighbors. The output, in case of classification problem, is the most frequent class. The similairty measure is expressed as a distance measure. These include Euclidean, Manhattan, Minkowski and Hamming distance. Or simply, once the data is stored in the system, its similarity is calculated for any input data point coming into the system.


```{r, echo=T}
knn_model <- train(diagnosis~.,
                   train_df,
                   method="knn",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   tuneLength=10,
                   trControl=model_control)
```


Predicted values for Neural Network model.

```{r}
knn_predicted <- predict(knn_model, test_df)
knitr::kable(as.data.frame(table(knn_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
knn_confusion_mat <- confusionMatrix(knn_predicted, test_df$diagnosis, positive = "M")
knitr::kable(knn_confusion_mat$table)
```


The overall accuracy of our model is `r round(knn_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(knn_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(knn_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
knn_predicted_prob <- predict(knn_model, test_df, type="prob")
#colAUC(knn_predicted_prob, test_df$diagnosis, plotROC=TRUE)
```





#### Random Forest

Random Forest is a supervised learning algorithm and can be understood as a bootstrapping algorithm with a Decision tree model, mostly, trained using 'bagging' method. In other words, Random forests built from several decision trees merged together to get a more stable and accurate predictions. It only important to note that the results tend to be more accurate with larger number of trees. Thi algorithm adds additonal randomness into the model with increasing number of trees.


```{r, echo=T}
rand_forest_model <- train(diagnosis~.,
                   train_df,
                   method="ranger",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   tuneLength=10,
                   trControl=model_control)
```


Predicted values for random forest model.

```{r}
rand_forest_predicted <- predict(rand_forest_model, test_df)
knitr::kable(as.data.frame(table(rand_forest_predicted)))
```


Summary based on $textit{Confusion Matrix}$.

```{r, echo=T}
rand_forest_confusion_mat <- confusionMatrix(rand_forest_predicted, test_df$diagnosis, positive = "M")
knitr::kable(rand_forest_confusion_mat$table)
```


The overall accuracy of our model is `r round(rand_forest_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(rand_forest_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(rand_forest_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
rand_forest_confusion_prob <- predict(rand_forest_model, test_df, type="prob")
#colAUC(rand_forest_confusion_prob, test_df$diagnosis, plotROC=TRUE)
```



#### Naive Bayes

Naive Bayes is a classification problem based on Bayes' theorem. It assumes that the all the dependent variables are independent of each other, which generally not true in many real-life problems. In other words, it assumes that the presence of a given feature in a given class is completely unrelated to the presence of any other features. The application of Naive Bayes model is considered less complicated, mostly application in large datasets and provides a way to calculte the posterior probabilities.


```{r, echo=T}
naive_bayes_model <- train(diagnosis~.,
                   train_df,
                   method="nb",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   trace=F,
                   trControl=model_control)
```


Predicted values for Naive Bayes model.

```{r}
naive_bayes_predicted <- predict(naive_bayes_model, test_df)
knitr::kable(as.data.frame(table(naive_bayes_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
naive_bayes_confusion_mat <- confusionMatrix(naive_bayes_predicted, test_df$diagnosis, positive = "M")
knitr::kable(naive_bayes_confusion_mat$table)
```


The overall accuracy of our model is `r round(naive_bayes_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(naive_bayes_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(naive_bayes_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
naive_bayes_confusion_prob <- predict(naive_bayes_model, test_df, type="prob")
#colAUC(naive_bayes_confusion_prob, test_df$diagnosis, plotROC=TRUE)
```




#### Support Vector Machine (SVM) - with radial kernel

In this ML algorithm, the input vector is initially mapped into feature space of higher dimensionality and identifies the hyperplane that seperates the data points into two classes. The aim is to maximize the marginal distance between the decision hyperplane and closest boundary data points. In other words, we plot each data point in a n-dimensional space, where n is the number of features in the dataset. We then find the line that seperates the data into two different classes. The line should be such that the distance from the closest point in each of the two classes is maximized.

```{r, echo=T}
svm_model <- train(diagnosis~.,
                   train_df,
                   method="svmRadial",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   trace=F,
                   trControl=model_control)
```


Predicted values for Vector Machine (SVM) - with radial kernel.

```{r}
svm_predicted <- predict(svm_model, test_df)
knitr::kable(as.data.frame(table(svm_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
svm_confusion_mat <- confusionMatrix(svm_predicted, test_df$diagnosis, positive = "M")
knitr::kable(svm_confusion_mat$table)
```



The overall accuracy of our model is `r round(svm_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(svm_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(svm_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
svm_confusion_prob <- predict(svm_model, test_df, type="prob")
#colAUC(svm_confusion_prob, test_df$diagnosis, plotROC=TRUE)
```



#### Extending Models with PCA and LDA

We extend some of the models fitted above using LDA or/and PCA to assess whether there could some improvement in the models. Extended models are shown below.


##### Random Forest with PCA

We also fit random forest model with PCA.

```{r, echo=T}
rand_forest_pca_model <- train(diagnosis~.,
                   train_df,
                   method="ranger",
                   metric="ROC",
                   preProcess = c('center', 'scale', 'pca'),
                   trControl=model_control)
```


Predicted values for random forest model with PCA.

```{r}
rand_forest_pca_predicted <- predict(rand_forest_pca_model, test_df)
knitr::kable(as.data.frame(table(rand_forest_pca_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
rand_forest_pca_confusion_mat <- confusionMatrix(rand_forest_pca_predicted, 
                                                 test_df$diagnosis, positive = "M")
knitr::kable(rand_forest_pca_confusion_mat$table)
```


The overall accuracy of our model is `r round(rand_forest_pca_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(rand_forest_pca_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(rand_forest_pca_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
rand_forest_pca_confusion_prob <- predict(rand_forest_pca_model, test_df, type="prob")
#colAUC(rand_forest_pca_confusion_prob, test_df$diagnosis, plotROC=TRUE)
```



##### Neural Networks with PCA

We also fit NW model with PCA.

```{r, echo=T}
nn_pca_model <- train(diagnosis~.,
                   train_df,
                   method="nnet",
                   metric="ROC",
                   preProcess = c('center', 'scale', 'pca'),
                   tuneLength=10,
                   trace=F,
                   trControl=model_control)
```


Predicted values for NW model with PCA.

```{r}
nn_pca_predicted <- predict(nn_pca_model, test_df)
knitr::kable(as.data.frame(table(nn_pca_predicted)))
```


Summary based on $textit{Confusion Matrix}$.

```{r, echo=T}
nn_pca_confusion_mat <- confusionMatrix(nn_pca_predicted, 
                                                 test_df$diagnosis, positive = "M")
knitr::kable(nn_pca_confusion_mat$table)
```

The overall accuracy of our model is `r round(nn_pca_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(nn_pca_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(nn_pca_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
nn_pca_confusion_prob <- predict(nn_pca_model, test_df, type="prob")
#colAUC(nn_pca_confusion_prob, test_df$diagnosis, plotROC=TRUE)
```




##### Naive Bayes with LDA

We also fit Naive Bayes model with LDA.

```{r, echo=T}
nb_lda_model <- train(diagnosis~.,
                   train_lda_df,
                   method="nb",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   trace=F,
                   trControl=model_control)
```


Predicted values for Naive Bayes model with LDA.

```{r}
nb_lda_predicted <- predict(nb_lda_model, test_lda_df)
knitr::kable(as.data.frame(table(nb_lda_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
nb_lda_confusion_mat <- confusionMatrix(nb_lda_predicted, 
                                                 test_df$diagnosis, positive = "M")
knitr::kable(nb_lda_confusion_mat$table)
```


The overall accuracy of our model is `r round(nb_lda_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(nb_lda_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(nb_lda_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
nb_lda_confusion_prob <- predict(nb_lda_model, test_lda_df, type="prob")
#colAUC(nb_lda_confusion_prob, test_lda_df$diagnosis, plotROC=TRUE)
```




##### Neural Networks model with LDA

We also fit Neural Networks model with LDA.

```{r, echo=T}
nn_lda_model <- train(diagnosis~.,
                   train_lda_df,
                   method="nnet",
                   metric="ROC",
                   preProcess = c('center', 'scale'),
                   tuneLength=10,
                   trace=F,
                   trControl=model_control)
```


Predicted values for Neural Networks model with LDA.

```{r}
nn_lda_predicted <- predict(nn_lda_model, test_lda_df)
knitr::kable(as.data.frame(table(nn_lda_predicted)))
```


Summary based on $\textit{Confusion Matrix}$.

```{r, echo=T}
nn_lda_confusion_mat <- confusionMatrix(nn_lda_predicted, 
                                                 test_df$diagnosis, positive = "M")
knitr::kable(nn_lda_confusion_mat$table)
```


The overall accuracy of our model is `r round(nn_lda_confusion_mat$overall[1], 4)*100`%. In addition, our classifier correctly identified $\textit{M}$ `r round(nn_lda_confusion_mat$byClass[1], 4)*100`% of the time (correctly predicting $\textit{M}$ when indeed we should). Further, the true negatives (our specificity) is `r round(nn_lda_confusion_mat$byClass[2], 4)*100`%.


```{r, echo=T}
nn_lda_confusion_prob <- predict(nn_lda_model, test_lda_df, type="prob")
#colAUC(nn_lda_confusion_prob, test_lda_df$diagnosis, plotROC=T)
```


### Assesing Model Performance

In this Section, we describe some methods we've used in evaluating ML models fitted above. Specifically, we have:

* $\textbf{Accuracy}$ - Is the proportion (percentage) of correctly classifying all the data points.
* $\textbf{Kappa}$ - This provides the classification accuracy. It important where there are imbalances in classes.
* $\textbf{Sensitivity}$ - Is the true positive rate also called the recall. It is the number instances from the positive (first) class that actually predicted correctly.
* $\textbf{Specificity}$ - Is also called the true negative rate. Is the number of instances from the negative class (second) class that were actually predicted correctly.

We start by comparing the area under curve (AUC) of ROC curves. The AUC provides the models ability to discriminate between positive and negative classes. An AUC of $1$ implies that the model provide a perfect prediction while an AUC of 0.5 implies that the model is good as random.

```{r, echo=F}

old.par <- par(mfrow=c(2, 5))
colAUC(lda_predicted_prob, test_lda_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "LDA", cex = 1.5)
colAUC(nn_predicted_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "NN", cex = 1.5)
colAUC(knn_predicted_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "KNN", cex = 1.5)
colAUC(rand_forest_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "RF", cex = 1.5)
colAUC(naive_bayes_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "NB", cex = 1.5)
colAUC(svm_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "SVM", cex = 1.5)
colAUC(rand_forest_pca_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "RF_PCA", cex = 1.5)
colAUC(nn_pca_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "NN_PCA", cex = 1.5)
colAUC(nb_lda_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "NB_LDA", cex = 1.5)
colAUC(nn_lda_confusion_prob, test_df$diagnosis, plotROC=TRUE)
text(0.5, 0.5, "NN_LDA", cex = 1.5)

par(old.par)

```


We apply resample method to comapre the models. Resampling is a method of comparing the performance of various competing machine learning algorithms. It estimates point estimate of the performances (based on a number of samples) which are then compared to obtain the best performing model \textit{(See .pdf file)}.


```{r, echo=T}
models <- list(LDA=lda_model, NN=nn_model, KNN=knn_model,
                        RF = rand_forest_model, NB=naive_bayes_model, 
                        SVM=svm_model, RF_PCA=rand_forest_pca_model,
                        NN_PCA=nn_pca_model, NB_LDA=nb_lda_model, 
                        NN_LDA=nn_lda_model)
models_resamples <- resamples(models)
#summary(models_resamples)
```


Let's plot the resamples summary output.

```{r}
# Draw box plots to compare models
scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(models_resamples, scales=scales)
```



We further plot the correlation matrix between the models.

```{r}
models_correlation <- modelCor(models_resamples)
corrplot(models_correlation, method="number")
```


<!-- We further provide visual representation of ROC. We observe high variability in some models, specifically, NB and RF_PCA. On the other hand, NN_LDA and LDA provide high AUC but with some variability. -->

<!-- ```{r, error=T} -->
<!-- bwplot(models_resamples, metric="ROC") -->
<!-- ``` -->





#### Model Selection

LDA, NB_LDA and NN_LDA provide the highest accuracy and Kappa in comparisson to the other models.

```{r}
models_conf_mat <- list(LDA=lda_confusion_mat, NN=nn_confusion_mat, KNN=knn_confusion_mat,
                        RF = rand_forest_confusion_mat, NB=naive_bayes_confusion_mat, 
                        SVM=svm_confusion_mat, RF_PCA=rand_forest_pca_confusion_mat,
                        NN_PCA=nn_confusion_mat, NB_LDA=nb_lda_confusion_mat, 
                        NN_LDA=nn_lda_confusion_mat)

all_model_accuracy <- sapply(models_conf_mat, function(x){
  round(x$overall, 2)
})
knitr::kable(data.frame(all_model_accuracy))
```
In addition, NN_LDA model provides the highest sensitivity.

```{r, echo=T}
#function(x) x$byClass
all_model_results <- sapply(models_conf_mat, function(x){
  round(x$byClass, 2)
})
knitr::kable(data.frame(all_model_results))
```

To provide a summary of the best model, we pullout model which performs better in each metric. From the output below, we observe that the model with the highest sensitivity (detection of breast cancer cases) is NN_LDA.

```{r}
all_model_results_max <- apply(all_model_results, 1, which.is.max)

model_select <- data.frame(metric=names(all_model_results_max), 
                            best_model=colnames(all_model_results)[all_model_results_max],
                            value=mapply(function(x,y) {all_model_results[x,y]}, 
                            names(all_model_results_max), 
                            all_model_results_max))
rownames(model_select) <- NULL
names(model_select) <- c("Metric", "Best_model", "Value")
knitr::kable(data.frame(model_select))
```

### Conclusion

In conclusion, we have found that a model based on Neural Network and LDA provides a good classification of the data. This model has a sensitivity of 0.94.



