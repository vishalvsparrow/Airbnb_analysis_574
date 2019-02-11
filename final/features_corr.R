require('ggcorrplot')

raw_data = read.csv('final_data.csv',header=TRUE,na.strings = '')

View(raw_data)

nhbr_data = raw_data[,16:27]
amen_data = raw_data[,32:45]
all_binaries = raw_data[, 16:62]
colnames(all_binaries)

cor_dat = cor(nhbr_data)
cor_pvalues = cor_pmat(nhbr_data)

cor_dat
cor_pvalues


p_comp.nhbr = prcomp(nhbr_data)
p_comp.amen = prcomp(amen_data)
p_comp.dummies = prcomp(all_binaries)

summary(p_comp.nhbr)
summary(p_comp.amen)
summary(p_comp.dummies)


binary_PCs = p_comp.dummies$x[,1:26]
View(binary_PCs)
raw_data_1 <- raw_data_1[, -(16:62)]
raw_data_1 <- data.frame(raw_data_1, binary_PCs)

# Saved this dataframe as a csv file
write.csv(raw_data_1,file = "final_data_with_PCs.csv",row.names = FALSE)


hclust(dist(cor_data))

plot(hclust(dist(cor_dat)),hang = 0.1)

ggcorrplot(cor_dat, hc.order = TRUE, type = 'lower', ggtheme = ggplot2::theme_gray,
           colors = c("#6D9EC1", "white", "#E46726"),p.mat = cor_pvalues)

ggcorrplot(cor_pvalues, hc.order = TRUE, type = 'lower', ggtheme = ggplot2::theme_gray,
           colors = c("#6D9EC1", "white", "#E46726"), legend.title = 'p-values')

plot(p_comp,type = "l")


require(devtools)
install_github("ggbiplot", "vqv")


library(ggbiplot)

g <- ggbiplot(p_comp.dummies, obs.scale = 1, var.scale = 1, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)

require('rgl')
require('plot3D')

plotPCA <- function(x, nGroup) {
  n <- ncol(x) 
  if(!(n %in% c(2,3))) { # check if 2d or 3d
    stop("x must have either 2 or 3 columns")
  }
  
  fit <- hclust(dist(x), method="complete") # cluster
  groups <- cutree(fit, k=nGroup)
  
  if(n == 3) { # 3d plot
    plot3d(x, col=groups, type="s", size=1, axes=F)
    axes3d(edges=c("x--", "y--", "z"), lwd=3, axes.len=2, labels=FALSE)
    grid3d("x")
    grid3d("y")
    grid3d("z")
  } else { # 2d plot
    maxes <- apply(abs(x), 2, max)
    rangeX <- c(-maxes[1], maxes[1])
    rangeY <- c(-maxes[2], maxes[2])
    plot(x, col=groups, pch=19, xlab=colnames(x)[1], ylab=colnames(x)[2], xlim=rangeX, ylim=rangeY)
    lines(c(0,0), rangeX*2)
    lines(rangeY*2, c(0,0))
  }
}

plotPCA(raw_data[1:3],9)

browseURL(paste("file://", writeWebGL(dir=file.path("C://", "webGL"), width=700), sep=""))


# Reporting the table 1

# Remove ID and geo location features

remove.id_ID = which(colnames(raw_data) =='ID')
remove.id_long = which(colnames(raw_data) =='longitude')
remove.id_lat = which(colnames(raw_data) =='latitude')

raw_data = raw_data[, -c(remove.id_ID, remove.id_lat, remove.id_long)]

View(as.data.frame(summary(raw_data)))

count = 13
for(feature in raw_data[,13:59])
{
  print(mapply(`[[`, dimnames(raw_data), count))
  print(table(feature))
  count = count + 1 
  
  
}
