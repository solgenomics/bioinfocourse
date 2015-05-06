source("http://bioconductor.org/biocLite.R")
biocLite("BiocUpgrade")
biocLite("cummeRbund")
library(cummeRbund)
browseVignettes("cummeRbund")

setwd("~/Desktop/ch4_demo_dataset/cuffdiff_out/")
cuff <- readCufflinks()
cuff

##https://pods.iplantcollaborative.org/wiki/display/eot/RNA-Seq_tutorial#RNA-Seq_tutorial-Step5%3AExaminingthegeneexpressiondata
#The squared coefficient of variation is a normalized measure of cross-replicate variability that can be useful for evaluating the quality your RNA-seq data. Run an SCV plot.
png(filename = 'fpkm_scv.png', width = 800, height = 800, units = 'px')
fpkmSCVPlot(genes(cuff))
dev.off()

#plot dispersion
disp<-dispersionPlot(genes(cuff))
disp
png(filename = 'dispersion.png', width = 800, height = 800, units = 'px')
disp<-dispersionPlot(genes(cuff))
dev.off()

#Draw a density plot of genes in the two samples.
dens <- csDensity(genes(cuff))
png(filename = 'density.png', width = 800, height = 800, units = 'px')
csDensity(genes(cuff))
dev.off()

#scatterplot
png(filename = 'scatter.png', width = 800, height = 800, units = 'px')
csScatter(genes(cuff), 'q1', 'q2',smooth=T)
dev.off()

#boxplot
png(filename = 'boxplot.png', width = 800, height = 800, units = 'px')
csBoxplot(genes(cuff))
dev.off()

#boxplot with replicates
png(filename = 'boxplot_rep.png', width = 800, height = 800, units = 'px')
csBoxplot(genes(cuff),replicates=T)
dev.off()

#volcano plot
png(filename = 'volcano.png', width = 2000, height = 2000, units = 'px')
csVolcanoMatrix(genes(cuff))
dev.off()

#sig genes
sig <- getSig(cuff, alpha=0.01, level='genes')
length(sig)

#get data from cuff database
sigGenes <- getGenes(cuff,sig)
sigGenes

#get 100 significant genes
sigGenes50 <- getGenes(cuff,tail(sig,50))
png(filename = 'thin_heatmap.png', width = 400, height = 1000, units = 'px')
csHeatmap(sigGenes50, cluster='row')
dev.off()

test_gene<-getGene(cuff,'mRNA:Solyc04g005050.1')
png(filename = 'test_plot.png', width = 2000, height = 2000, units = 'px')
expressionPlot(isoforms(test_gene), logmode=T)
dev.off()

#Finally, consider gene FP3, we can find other genes in the database with similar expression patterns
sim = findSimilar(cuff, 'mRNA:Solyc04g005050.1', n=5)
sim
expressionPlot(sim,logMode=T,showErrorbars=F)
b<-expressionBarplot(sim)

#Heatmap with similar genes
h<-csHeatmap(sim,cluster='both')
h