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

subdirs += testtex Presentation
Ignore += ${subdirs}

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

## Descriptive
descriptive.Rout: clean.Rout descriptive.R

## Caret package

## Inputs and model control parameters
control_parameters.Rout: descriptive.Rout control_parameters.R

## Define a partition function
data_partition.Rout: control_parameters.Rout data_partition.R

## Define the model_control function
training_control.Rout: data_partition.Rout training_control.R

## Training and Tuning parameters
tuning_parameters.Rout: training_control.Rout tuning_parameters.R

## Training function
train.Rout: tuning_parameters.Rout train.R

## Fit desired models. You can add the models within this function
model_fits.Rout: train.Rout model_fits.R

## Plot tuning/pruning results
pruning_plots.Rout: model_fits.Rout pruning_plots.R

## Make prediction and plot some metrics
model_predictions.Rout: pruning_plots.Rout model_predictions.R
## .model_predictions.wrapR.rout for warnings

## ROC-AUC Confidence Intervals
auc_ci.Rout: model_predictions.Rout auc_ci.R

## Final project writeup
## JD: Try not to be linear like this; just pass what you need to pass
## Easier for people to figure out what you've done
var_importance.Rout: auc_ci.Rout var_importance.R
predicted_prob.Rout: var_importance.Rout predicted_prob.R
predicted_class.Rout: predicted_prob.Rout predicted_class.R
RF_Plots.Rout: predicted_class.Rout RF_Plots.R
BOOST_Plots.Rout: RF_Plots.Rout BOOST_Plots.R
KNN_Plots.Rout: BOOST_Plots.Rout KNN_Plots.R
NN_Plots.Rout: KNN_Plots.Rout NN_Plots.R
auc_Plots.Rout: NN_Plots.Rout auc_Plots.R
roc_Plots.Rout: auc_Plots.Rout roc_Plots.R
test_summary.Rout: auc_Plots.Rout test_summary.R

# Run all the inputs for report
run_all: auc_ci.Rout.pdf var_importance.Rout.pdf predicted_prob.Rout.pdf predicted_class.Rout.pdf RF_Plots.Rout.pdf BOOST_Plots.Rout.pdf KNN_Plots.Rout.pdf NN_Plots.Rout.pdf auc_Plots.Rout.pdf roc_Plots.Rout.pdf test_summary.Rout

## Writeup
Sources += Steve_FinalProject.tex Steve_FinalProject.bib
McMasterfull_colour.jpg:
	wget -O $@ "https://roads.mcmaster.ca/images/McMasterfull_colour.jpg/$@"
Steve_FinalProject.pdf: run_all McMasterfull_colour.jpg Steve_FinalProject.tex

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
	rm *Rout.*  *.Rout .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog *.Rlog *.rdeps *.rda .*.rdeps .*.rda *.vrb *.toc *.out *.nav *.snm *.log *.aux *.bbl *.blg *.dvi *.ps *.gz

######################################################################


### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/wrapR.mk
-include $(ms)/texdeps.mk
-include $(ms)/pandoc.mk
-include $(ms)/autorefs.mk

