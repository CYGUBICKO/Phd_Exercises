### Hooks for the editor to set the default target

current: target
-include target.mk

##################################################################

## Defs

# stuff

Sources += Makefile .ignore 
Ignore += .gitignore

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

Ignore += wdbc.data wdbc.names
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

## Compare models

compare_models.Rout: lda.Rout qda.Rout compare_models.R

## Machine learning models using caret package

data_partition.Rout: clean.Rout data_partition.R

training_control.Rout: training_control.R

lda_model.Rout: data_partition.Rout training_control.Rout lda_model.R

qda_model.Rout: data_partition.Rout training_control.Rout qda_model.R

nn_model.Rout: data_partition.Rout training_control.Rout nn_model.R

knn_model.Rout: data_partition.Rout training_control.Rout knn_model.R

## Evaluate ml models and compare the AUC estimates

evaluate_model.Rout: lda_model.Rout qda_model.Rout knn_model.Rout nn_model.Rout evaluate_model.R

######################################################################

clean: 
	rm .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk

