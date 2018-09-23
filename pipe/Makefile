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

## People who want to let us install packages for them can run this script
## May require sudo for some people
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

######################################################################


### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk

