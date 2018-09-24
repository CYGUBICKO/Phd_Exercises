# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.lda.RData')
load('.qda.RData')

rtargetname <- "compare_models"
pdfname <- ".compare_models.Rout.pdf"
csvname <- "compare_models.Rout.csv"
rdsname <- "compare_models.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file compare_models.wrapR.r
source('compare_models.R', echo=TRUE)
# Wrapped output file compare_models.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script compare_models.wrapR.r (or something it called) did not close properly
save.image(file=".compare_models.RData")

