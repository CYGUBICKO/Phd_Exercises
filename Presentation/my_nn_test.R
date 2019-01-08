library(openxlsx)
library(dplyr)
set.seed(3752)

df <- read.xlsx("wdbc_dataset.xlsx", sheet = 2)

x <- (df
	%>% select(-id_number, -diagnosis)
	%>% mutate_at(
        funs(as.numeric(scale(.)))
        , .vars = vars()
        )
)

y <- ifelse(df$diagnosis=="M", 1, 0)

hidden <- 15
n_ind_vars <- ncol(x) + 1
w1 <- matrix(rnorm(n_ind_vars * hidden), n_ind_vars, hidden)
w2 <- as.matrix(rnorm(hidden + 1))

y_hat <- feedfoward(x, w1, w2)
yhat_df <- data.frame(y = y
	, y_hat = ifelse(y_hat>0.5, 1, 0))
table(yhat_df)
