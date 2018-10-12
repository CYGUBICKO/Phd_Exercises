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

Sources += simple.tex

simple.pdf: simple.tex

clean: 
	rm .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

plot.Rout: plot.R

## Drop = ~/Dropbox
Sources += $(wildcard *.rmu)
refs.bib: refs.rmu
refs.html: refs.rmu

######################################################################

### Makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk

-include $(ms)/texdeps.mk
## Documentation makestuff/texdeps.md
## File makestuff/texdeps.mk

-include $(ms)/pandoc.mk

-include $(ms)/autorefs.mk
## Documentation makestuff/autorefs.md
## File makestuff/autorefs.mk
