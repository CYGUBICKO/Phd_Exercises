# WDBC-Codes
### Hooks for the editor to set the default target

current: target
-include target.mk

##################################################################

## Defs

# stuff

Sources += Makefile

ms = makestuff
Ignore += local.mk
-include local.mk
-include $(ms)/os.mk

# -include $(ms)/perl.def

Ignore += $(ms)
Makefile: $(ms) $(ms)/Makefile
$(ms):
	ln -s ../makestuff $@

######################################################################

## Implementing Neural Network Algorithm using Gradient Descent

## Training and test data already saved

new_data_partition.Rout: ../data_partition.Rout new_data_partition.R

## Setup inputs

nn_setup.Rout: new_data_partition.Rout nn_setup.R

## Forward propagation

sigmoid.Rout: sigmoid.R

feedforward.Rout: feedforward.R

## Implement feed forward

ff_out.Rout: sigmoid.Rout feedforward.Rout nn_setup.Rout ff_out.R

## Implement back propagation

sigmoidPrime.Rout: sigmoidPrime.R

backprop.Rout: backprop.R

bp_out.Rout: ff_out.Rout sigmoidPrime.Rout backprop.Rout bp_out.R

## Train the model: Put everything together
## Actually, above step by step is just to show the process but we can run everything at once.

trainMynnet.Rout: trainMynnet.R

nnet_out.Rout: nn_setup.Rout sigmoid.Rout feedforward.Rout sigmoidPrime.Rout backprop.Rout trainMynnet.Rout nnet_out.R

## Testing and prediction

predictNnet.Rout: predictNnet.R

nnet_test.Rout:nnet_out.Rout predictNnet.Rout nnet_test.R

## ROC-AUC Plot

mynnet_plot.Rout: nnet_test.Rout mynnet_plot.R

## Bootstrapping

aucBoot.Rout: aucBoot.R

boot_auc.Rout: nnet_test.Rout aucBoot.Rout boot_auc.R

## Presentation

%.tex: %.Rnw
	Rscript -e "library(knitr); knit('$*.Rnw')"

Sources += nn_presentation.Rnw
Ignore += nn_presentation.tex
## nn_presentation.pdf: nn_presentation.Rnw

Sources += tanh.R
tanh.Rout: sigmoid.Rout tanh.R

Ignore += *.rs.tex:
nn_presentation.rs.tex:
	$(CP) nn_presentation.tex $@

nn_presentation.pdf: nn_presentation.tex

Ignore += *.diff
nn_presentation.diff: nn_presentation.rs.tex nn_presentation.tex 
	$(diff)


######################################################################

clean: 
	rm *Rout.*  *.Rout .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

######################################################################

### Makestuff

-include $(ms)/texdeps.mk
-include $(ms)/pandoc.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/wrapR.mk
-include $(ms)/autorefs.mk
