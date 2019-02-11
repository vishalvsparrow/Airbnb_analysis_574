dat = read.csv('C:\\Users\\vishal\\PycharmProjects\\airbnb_analysis\\amenities_dummy.csv', header = TRUE, na.strings = '')
View(dat)

require('ggcorrplot')

cor_data = dat[,3:length(dat)]


cor_dat = cor(dat[,3:length(dat)])
cor_pvalues = cor_pmat(dat[,3:length(dat)])

cor_dat
cor_pvalues



p_comp = prcomp(dat[,3:length(dat)])

summary(p_comp)

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

g <- ggbiplot(p_comp, obs.scale = 1, var.scale = 1, ellipse = TRUE, 
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

plotPCA(p_comp$x[,1:3],3)

# browseURL(paste("file://", writeWebGL(dir=file.path("C://", "webGL"), width=700), sep=""))
