
## We should probably be using tidy functions, e.g., readr instead of data.table
## Please do NOT use FALSE and TRUE as short-hand for TRUE and FALSE, unless you are 
## using punch cards instead of a keyboard ☺

library(data.table)
library(stringr)
wdbc <- fread(input_files[[1]], showProgress=FALSE)
desc_file <- readLines(input_files[[2]])

## What is this doing? Adding 2 seems weird
var_info_pos <- grep(". Attribute information", desc_file, ignore.case = TRUE)+2
var_info <- desc_file[var_info_pos:(var_info_pos+5+ncol(wdbc)/3)] ## K, this line jst seems crazy
var_info <- var_info[!var_info %in% c("", "Ten real-valued features are computed for each cell nucleus:", "3-32)")]
var_info <- sub('.*\\\t', '', var_info)
var_info <- sub('.*\\) \\b', '', var_info)
var_table <- data.frame(vars=var_info)
var_table$labels <- as.character(var_table$vars)
var_table$vars <- str_wrap(tolower(sub('\\(.*', '', var_table$vars)))
var_table$vars <- sub(" ", "_", var_table$vars)
rep_vars <- var_table[3:nrow(var_table), ]
var_table <- rbind(var_table, rep_vars[rep(seq_len(nrow(rep_vars)), 2), ])
measurements <- rep(c("mean", "se", "worst"), each=10)
var_table$vars[3:nrow(var_table)] <- paste(var_table$vars[3:nrow(var_table)], measurements, sep = '_')
measurements <- rep(c("Mean", "Standard error", "Worst"), each=10)
var_table$labels[3:nrow(var_table)] <- paste(var_table$labels[3:nrow(var_table)], measurements, sep = ' - ')
colnames(wdbc) <- var_table$vars

# rdsave(var_table, wdbc)
