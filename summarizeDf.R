# `summarizeDf` summariz(s)es dataframe. Computes ([min, max]; mean (sd)) for numerical or integer variables and frequency distribution (percent) for categorical variables.

# Inputs:
## `df` - Input dataframe
## `output` - Specifies the output structure. `output = "simple"` returns R-output-like output. `output = "tex"` returns xtable ready format.
## digits - Number of digits to return.

# Details:
# For categorical variables with several categories, `output = "tex"` is preferrable. Add sanitize.text.function = function(x){x} to xtable print function for .tex.

# Value:
# It returns an object of class `data.frame`.

summarizeDf <- function(df, output = c("simple", "tex"), digits = 1){
	if (!missing(output) & sum(!output %in% c("simple", "tex")) > 0){
		stop("output can only be 'simple' or 'tex'")
	}
  	vars <- colnames(df)
  	df_summary <- data.frame(Variable = rep(NA, length(vars))
   	, Type = rep(NA, length(vars))
   	, Summary = rep(NA, length(vars))
	)
  	for (i in 1:length(vars)){
		vals <- df[, vars[[i]]]
    	if (class(vals) == "numeric" | class(vals) == "integer"){
			df_summary[["Type"]][[i]] <- "numeric"
      	df_summary[["Variable"]][[i]] <- vars[[i]]
      	df_summary[["Summary"]][[i]] <- paste0("["
				, round(min(vals), digits), ", "
				, round(max(vals), digits), "]; "
        		, round(mean(vals), digits), " ("
				, round(sd(vals), digits), ")"
			)
		} else{
			df_summary[["Type"]][[i]] <- "categorical"
      	df_summary[["Variable"]][[i]] <- vars[[i]]
      	perc <- sort(round(prop.table(table(vals))*100, digits)
				, decreasing = TRUE
			)
      	if (missing(output) | sum(output %in% "simple") > 0){
				perc <- paste0(names(perc), " (", perc, "%)")
				df_summary[["Summary"]][[i]] <- paste0(perc
					, collapse = "; \n"
				)
			} else{
        		perc <- paste0(names(perc), " (", perc, "\\%)")
        		df_summary[["Summary"]][[i]] <- paste0(perc
					, collapse = "; \\\\  & & "
				)
			}
		}
	}
	return(df_summary)
}
