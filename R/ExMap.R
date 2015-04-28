install.packages("maps")
library(maps)

map() # low resolution map of the world
map("usa") # national boundaries
map("world","China")
map("world","Germany")
map("world","Spain")
map("world","india")
map("world","Japan")

hist(rnorm(100))
boxplot(rnorm(100))

as.array(letters)
dim(as.array(letters))

data0<-array(1:3, c(2,4))
class(data0)
dim(data0)
data0
xyz <- array(c(1:27), dim=c(3, 3, 3))
dim(xyz)
xy <- matrix(c(1:9), ncol=3, nrow=3)
xy
nsubjects=200
nmarkers = 2000

data1<-matrix(sample(c(0,1,2),nsubjects*nmarkers,replace=T),nrow=nsubjects,ncol = nmarkers , byrow = TRUE)

dim(data1)

hist(apply(data1,1,mean))
hist(apply(data1,2,mean))


data1.pca<-prcomp(data1)
names(data1.pca)
dim(data1.pca$x)
summary(data1.pca)

class(data1)

heatmap(data1)
biplot(prcomp(data1))

accessions<-c("Alisa Craig", "Black Cherry", "Comete", "Gnom")
fruit_size<-matrix(c(7, 8, 5, 7, 6, 8, 9, 8), ncol=2, nrow=4, byrow=TRUE, dimnames=list(accessions, c(2006, 2007)))
sugar_content<-matrix(c(2.1, 3.2, 3, 2.1, 4.1, 2.3, 2.8, 3.1), ncol=1, nrow=4, byrow=TRUE, dimnames=list(accessions, c(2008)))

phenome<-data.frame(fruit_size, sugar_content);
dim(phenome)
phenome

test.list<-list()

test.list[[1]]<-phenome
test.list[[2]]<-data1
test.list[[3]]<-data0


install.packages("gdata")
library("gdata")      					          >
packageDescription("gdata")
ll(dim=T)