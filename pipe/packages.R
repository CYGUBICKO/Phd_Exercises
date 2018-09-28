pkgs <- c(
	"data.table", "Amelia", "stringr", "dplyr", "corrplot"
	, "caret", "MASS", "openxlsx"
	, "ROCR", "caTools", "e1071", "ranger", "nnet", "ggplot2"
)

if (!"pacman" %in% installed.packages()[,1]){
	install.packages("pacman")
}

pacman::p_load(pkgs, install = T, character.only = T)

