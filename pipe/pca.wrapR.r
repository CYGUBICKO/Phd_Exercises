# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.clean.RData')

rtargetname <- "pca"
pdfname <- ".pca.Rout.pdf"
csvname <- "pca.Rout.csv"
rdsname <- "pca.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file pca.wrapR.r
source('pca.R', echo=TRUE)
# Wrapped output file pca.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script pca.wrapR.r (or something it called) did not close properly
save.image(file=".pca.RData")

