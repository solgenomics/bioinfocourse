install.packages("FactoMineR")
library(FactoMineR)

load("PCA_data.RData")
pop.5.pca<-PCA(example.data,quali.sup = 1,graph=F)
plot(pop.5.pca,habillage=1,col.hab=c("red","burlywood4","cadetblue","chartreuse4","gray4"),label="none",invisible="quali")

random.data<-matrix(sample(c(-1,0,1),938*1000,replace=T),nrow=938,ncol = 1000 , byrow = TRUE)
random.data.2<-cbind(rep(1,938),random.data)

random.data.pca<-PCA(random.data.2,quali.sup = 1,graph=F)
plot(random.data.pca,habillage=1,col.hab=c("red"),label="none",invisible="quali")
