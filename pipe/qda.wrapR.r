# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.clean.RData')

rtargetname <- "qda"
pdfname <- ".qda.Rout.pdf"
csvname <- "qda.Rout.csv"
rdsname <- "qda.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file qda.wrapR.r
source('qda.R', echo=TRUE)
# Wrapped output file qda.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script qda.wrapR.r (or something it called) did not close properly
save.image(file=".qda.RData")

