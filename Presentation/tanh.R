library(tidyverse)

library(ggplot2)
theme_set(theme_bw())

set.seed(237)

# Function

inscale <- 1/2
inbias <- 0
outscale <- 1/2
outbias <- 1/2

x <- seq(-3, 3, 0.1)
df <- (data.frame(x = x)
	%>% mutate(
		xs = inscale*x + inbias
		, Sigmoid = sigmoid(x)
		, Tanh = 2*sigmoid(2*xs) - 1
		, tscale = outscale*Tanh+outbias
	)
	%>% gather(Act_Func, Value, c(Sigmoid, tscale))
)

p2 <- (
  ggplot(df, aes(x = x, y = Value, group = Act_Func, color = Act_Func)
         )
  + geom_line(size = 2)
  + labs(color = "Activation Function"
         #, title = "NN Activation functions"
         , x = "x"
         , y = NULL
         )
  + theme(legend.position = c(0.2, .9),
          plot.title = element_text(hjust = 0.5)
          )
)

