### Hooks for the editor to set the default target

current: target
-include target.mk

##################################################################

## Defs

# stuff

Sources += Makefile .ignore .gitignore

ms = makestuff
-include $(ms)/os.mk

# -include $(ms)/perl.def

## makestuff as uplink
Sources += $(ms)
Makefile: $(ms) $(ms)/Makefile
$(ms): ../makestuff
	/bin/ln -fs $< $@

######################################################################

all: lda.Rout qda.Rout

## People who want to let us install packages for them can run this script
## May require sudo fogtr some people
packages.Rout: packages.R

######################################################################

## Data

##  Get files, clean data

# for cannibalizing
Sources += tmp.R

## del wdbc.data wdbc.names ##
Sources += wdbc.data wdbc.names
wdbc.data wdbc.names:
	wget -O $@ "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/$@"

Sources += *.R

wdbc.Rout: wdbc.data wdbc.names wdbc.R

## Make the excel file; this is a digression from the main pipeline
Ignore += *.xlsx
wdbc_excel.Rout: wdbc.Rout wdbc_excel.R
wdbc_excel.xlsx: wdbc_excel.Rout ;

clean.Rout: wdbc.Rout clean.R

######################################################################

## Some analyses

pca.Rout: clean.Rout pca.R

lda.Rout: clean.Rout lda.R

qda.Rout: clean.Rout qda.R

## Compare lda to qda; lda is better!

compare_models.Rout: lda.Rout qda.Rout compare_models.R

######################################################################

## Caret package

## Define a partition function
data_partition.Rout: clean.Rout data_partition.R

## Define the model_control function
training_control.Rout: training_control.R

lda_model.Rout: data_partition.Rout training_control.Rout lda_model.R

qda_model.Rout: data_partition.Rout training_control.Rout qda_model.R

knn_model.Rout: data_partition.Rout training_control.Rout knn_model.R

logistic_model.Rout: data_partition.Rout training_control.Rout logistic_model.R

nn_model.Rout: data_partition.Rout training_control.Rout nn_model.R

## Compare the AUC estimates

compare_auc.Rout: nn_model.Rout lda_model.Rout qda_model.Rout knn_model.Rout logistic_model.Rout compare_auc.R

######################################################################

clean: 
	rm .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
-include $(ms)/flextex.mk
