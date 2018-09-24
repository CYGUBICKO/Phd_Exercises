# This file was generated automatically by wrapR.pl
# You probably don't want to edit it


input_files <- c("wdbc.data", "wdbc.names")
rtargetname <- "wdbc"
pdfname <- ".wdbc.Rout.pdf"
csvname <- "wdbc.Rout.csv"
rdsname <- "wdbc.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file wdbc.wrapR.r
source('wdbc.R', echo=TRUE)
# Wrapped output file wdbc.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script wdbc.wrapR.r (or something it called) did not close properly
save(file=".wdbc.RData", var_table, wdbc)


