install.packages("CMplot")
library(CMplot)
	data <- read.table("C:/Users/john.connell/Documents/edited_FilteredQualSNPsINDELlocBiAutoDepthFilterMM30_MD3.recode_CMplot_table.txt", header=F)
	CMplot(data,
		plot.type="d",
		bin.size=1e5, 
		bin.breaks = seq(0,3500,500),
		chr.labels = sort(unique(data[[2]]),decreasing = TRUE),
		chr.den.col=c("blue", "yellow", "orange", "red"),
		file="jpg",
		file.name="pg2bd_100kb_snp_windows",
		dpi=300,
		main="pg2bd - 100kb SNP window",
		file.output=TRUE,
		verbose=TRUE,
		width=9,height=30
)
