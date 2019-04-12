# WDBC-Codes
### Hooks for the editor to set the default target

current: target
-include target.mk

##################################################################

## Defs

# stuff

Sources += Makefile 

msrepo = https://github.com/dushoff
ms = makestuff
Ignore += local.mk
-include local.mk
-include $(ms)/os.mk

# -include $(ms)/perl.def

Ignore += $(ms)
## Sources += $(ms)
Makefile: $(ms) $(ms)/Makefile
$(ms):
	git clone $(msrepo)/$(ms)

######################################################################

## We will delete pipe soon

subdirs += testtex

######################################################################

Sources +=  notes.txt 

## Code

wdbc.data wdbc.names:
	wget -O $@ "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/$@"

Sources += $(wildcard *.R)

wdbc.Rout: wdbc.data wdbc.names wdbc.R

## Make the excel file; this is a digression from the main pipeline
Ignore += *.xlsx
wdbc_excel.Rout: wdbc.Rout wdbc_excel.R
wdbc_excel.xlsx: wdbc_excel.Rout ;

clean.Rout: wdbc.Rout clean.R

######################################################################

## Some analyses

## Caret package

## Inputs and model control parameters
control_parameters.Rout: control_parameters.R

## Define a partition function
data_partition.Rout: control_parameters.Rout clean.Rout data_partition.R

## Define the model_control function
training_control.Rout: control_parameters.Rout training_control.R

## Training and Tuning parameters
tuning_parameters.Rout: training_control.Rout tuning_parameters.R

## Training function
train.Rout: data_partition.Rout tuning_parameters.Rout train.R

## Fit desired models. You can add the models within this function
model_fits.Rout: train.Rout model_fits.R

## Plot tuning/pruning results
pruning_plots.Rout: model_fits.Rout pruning_plots.R

## Make prediction and plot some metrics
model_predictions.Rout: model_fits.Rout model_predictions.R
## .model_predictions.wrapR.rout for warnings

## ROC-AUC Confidence Intervals
auc_ci.Rout: model_predictions.Rout auc_ci.R


######################################################################

# Step by step fitting to understand Tuning and Hyperparameters.
## Neural Networks

## Data preprocessing
prepros_df.Rout: data_partition.Rout prepros_df.R

nn_setup.Rout: prepros_df.Rout nn_setup.R

## Understanding cv and weight decay
nnet_cv.Rout: data_partition.Rout nnet_cv.R
## nnet_cv.Rout.pdf:

####################################################################

## Polynomial Regression

polyr.Rout: model_predictions.Rout polyr.R


######################################################################

clean: 
	rm *Rout.*  *.Rout .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

######################################################################


### Makestuff

-include $(ms)/pandoc.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/wrapR.mk
