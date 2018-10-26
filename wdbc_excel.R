
library(openxlsx)

xlstarget <- paste0(rtargetname, ".xlsx")
write.xlsx(
	list(Description = var_table, wdbc_data = wdbc)
	, xlstarget
)

# rdnosave

