# This script contains all the model control parameters and any input values  
# which might need to be changed in the course of our analysis

# Data partitioning
part_ratio <- 0.75 # Train : test ratio
lst <- FALSE # Whether/not to return a list (TRUE) or a data matrix
set.seed(257)

# Train control (training_control.R). See ?trainControl
ctl_method <- "cv"
ctl_number <- 10
ctl_classProb <- TRUE 
summFunc <- "twoClassSummary"
