library(dplyr)

## factorFunc is not doing anything!
## I am not sure why you are carrying id_number around; it just gets in the way
## You had it as a number (should be a factor),
## and I'm not even sure whether it wound up in some of the analyses

wdbc <- (wdbc 
	%>% select(-id_number)
	%>% mutate(diagnosis=factor(diagnosis))
)

## Took out the missingness checks, because I feel like we would see that in the summary
summary(wdbc)

