library(xtable)
library(dplyr)
library(tidyr)

library(ggplot2)
theme_set(theme_bw() +
            theme(panel.spacing=grid::unit(0,"lines")))
source("summarizeDf.R")

# Variable description file
var_table$vars <- gsub("_", "", var_table$vars)
names(wdbc) <- gsub("_", "", names(wdbc))
desc <- (var_table 
	%>% filter(vars != "idnumber")
	%>% rename(Variable = vars)
	%>% mutate(labels = gsub("\\^2", "\\$^2\\$", labels))
	%>% rename(Labels = labels)
)
desc_df <- summarizeDf(wdbc, output = "tex", digits = 2)
desc_df$Summary[1] <- "B (62.7\\%); \\\\  & & & M (37.3\\%)"
desc_df <- left_join(desc, desc_df)

# Create description file
bold <- function(x) {paste('\\textbf{',x,'}', sep ='')}
gray <- function(x) {paste('\\textcolor{black}{',x,'}', sep ='')}
var_summary1 <- desc_df
names(var_summary1)[4] <- "Summary ([min, max]; mean (sd))"
var_summary1 <- xtable(var_summary1)
var_summary1_tex <- print(var_summary1
	, file = "var_summary1.tex" 
	, sanitize.text.function = function(x){x}
	, sanitize.colnames.function=bold
	, only.contents = TRUE
	, include.rownames = FALSE
	, timestamp = NULL
)
print(var_summary1)


# Numeric variables
plots_list <- list()
plot_vars <- colnames(wdbc)[2:31]
features_df <- (wdbc
	%>% select(plot_vars)
	%>% scale(.)
	%>% as.data.frame()
	%>% mutate(diagnosis = wdbc$diagnosis)
)
diagnosis_mean <- (features_df
	%>% group_by(diagnosis)
	%>% summarise_at(plot_vars, mean, na.rm = TRUE)
	%>% gather(vars, values, -diagnosis)
)
features_density_plot <- (features_df
	%>% select(c("diagnosis", plot_vars))
	%>% gather(vars, values, -diagnosis)
	%>% ggplot(aes(x = values, colour = diagnosis))
		+ geom_density(aes(fill = diagnosis), alpha = 0.3)
		#+ scale_colour_manual(values = c(1:10))
		#+ scale_fill_manual(values = c(1:10))
		+ scale_colour_brewer(palette="Dark2")
		+ geom_vline(data = diagnosis_mean, aes(xintercept = values, color = diagnosis),
				 linetype="dashed")
		+ theme(legend.position="bottom")
		+ facet_wrap(~vars, scales = "free")
)
ggsave("features_density_plot1.pdf"
	, features_density_plot 
	, width = 15.27
	, height = 8.50
)

