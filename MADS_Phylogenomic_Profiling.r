library(pheatmap)
library(vegan)

args<-commandArgs(TRUE)

# pre-treatment
  
data <- read.table(args[1],header=T)  # Sometimes You have to use this one! For problems above ! I dont  know why
data <- read.table("MADS_SynNet.sim.cleaned.infoclu",header = T)
#data$species <- substr(data$names,1,3) # extract first three letters of the gene name as species id
data$species <- substr(data$names,1,2) # extract first two letters of the gene name as species id
colnames(data) <-c("Gene","Cluster","Species")
data <- data[,c(1,3,2)]
	# Input
	# Gene	Species	Cluster
	# AlyrAL1G19310	Aly	13296
	# AlyrAL1G19350	Aly	75

# cluster by rows, Species by columns
out <- table(data$Cluster,data$Species) 

# Important: species order you have to change the content below, depending on the species you use.

	#myorder <- c('vra','van','pvu','gma','cca','tpr','mtr','adu',
	#'lja','Lan','car','pmu','ppe','pbr','mdo','roc','fve','Mno','Zju','hlu',
	#'aco','egu','Pda','mac','Dca','peq','Aof','Xvi','spo','lmi','zom','atr')
  
  #this is the full prefix
  #myorder <- c('ach','Ag','Ahyp','atr','bvu','can','cc',
  #            'cd','coc','Cqui','cs','dca','hel','Inil','Lj',
  #            'll','lt','lv','mgu','mm','Natt','nnu','pax','pg', 
  #             'sin','sly','spe','stu','ugi','vvi')
  
myorder <- c('Cd','lt','ll','lv','To','cc','mm','he','PG','Lj','Ag','Cs','dc','sp',
             'st','sl','ca','Na','pa','In','ug','si','mg','co','ac','Cq','Ah','Bv','vv','nn','at')
# In case, you miss species
order <- match(colnames(out),myorder)
new <- rbind(order, out)
new2 <- new[,order(new[1,])]
new3 <-new2[-1,]

#out <- out[,myorder]

write.table(new3,args[2],col.names =NA,quote=F) # export output
write.table(new3,"MADS_SynNet.sim.infoclu.profiled",col.names =NA,quote=F)
# Output sample

	# Aly ath atr can csi dca Ebr hel Lsa osa oth sly Tar TKS vvi
	# 1 28 28 0 65 53 43 0 59 67 25 17 59 112 9 84
	# 2 7 3 11 175 17 9 0 5 19 44 1 28 100 6 13
	# 3 36 62 15 16 18 12 0 39 22 36 5 14 48 3 32

matrixp <-data.matrix(new3)
#breaksList <- c(0,0.9,1.58,1.9,10) # Set range # 
#mycolor <- c("white","#E8E8E8","#909090","#303030") # Grey Scale
#mycolor <- c("white","#8FB0D7","#FDC87A","#F70C0E") # Red- Orange- Blue Scale #

# calculate the index of dissimilarity, clusters as neighborhoods, species as races
d <- vegdist(log2(matrixp+1),method="jaccard")
  # binary=T 
	# method	
	# Dissimilarity index, partial match to "manhattan", "euclidean", "canberra", "bray", "kulczynski", "jaccard", 
	# "gower", "altGower", "morisita", "horn", "mountford", "raup" , "binomial", "chao", "cao" or "mahalanobis".
f2_m.res <- hclust(d,method="ward.D")
	# "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA),
	# "median" (= WPGMC) or "centroid" (= UPGMC).

# Re-order clusters by clustering result
out2 <- new3[f2_m.res$order,]

# Done 
write.table(out2,args[3],col.names =NA,quote=F) # export output
write.table(out2,"MADS_SynNet.sim.infoclu.profiled.clustered",col.names =NA,quote=F) # export output

# Plot Clusters
#first determine the breaks, IMPORTANT STEP
#quantile break function
#quantile_breaks <- function(xs, n = 10) {
#  breaks <- quantile(xs, probs = seq(0, 1, length.out = n))
#  breaks[!duplicated(breaks)]
#}
#mat_breaks <- quantile_breaks(log2(matrixp+1), n = 11) #
#mat_breaks
#      0%      70%      90%     100% 
# 0.000000 1.000000 1.584963 7.665336

breaksList <- c(0,0.9,1.58,1.9,10) # four region requires four colors
#0-0.9 contains 0 log2(0+1)=0 white
#0.9-1.58 contains 1 log2(1+1)=1 blue
#1.58-1.9 contains 1.584 log2(2+1)=1.584 orange
#1.9-10 contains 2 log2(3-1024+1)=2-10 red cluster with nodes >= 3
mycolor <- c("white","#8FB0D7","#FDC87A","#F70C0E") # Red- Orange- Blue Scale #

#pdf('args[3].pdf',width=8,height=8,onefile=FALSE) 
 pheatmap( log2(matrixp+1), # Better 
          breaks = breaksList,
			 color = mycolor,
          cluster_rows = f2_m.res,   # THIS IS GREAT! IMPORT 
          cluster_cols=F,
			    show_rownames = FALSE,
			    legend = FALSE,
          main="jaccard+ward.D",
          border_color=NA,
		  filename = "profiling_ordered.pdf", 
		  width = 8, height = 8
          )
 #out2 is the matrix after ordered by the clustering result
 pheatmap(log2(out2+1), # Better 
          breaks = breaksList,
          color = mycolor,
          cluster_rows = F,   # THIS IS GREAT! IMPORT 
          cluster_cols=F,
          #show_rownames = FALSE,
          legend = FALSE,
          main="jaccard+ward.D",
          border_color="grey60",
          cutree_rows = 5,
          cellwidth = 10,
          cellheight = 4,
          filename = "MADS_profiling2.pdf", 
          #width = 8, height = 10,
          fontsize_row=5
 )
 
 ## use clustered output2
 pheatmap( log2(out2+1), # Better 
           breaks = breaksList,
           color = mycolor,
           #cluster_rows = f2_m.res,   # THIS IS GREAT! IMPORT 
           cluster_rows=F,
           cluster_cols=F,
           #show_rownames = FALSE,
           legend = FALSE,
           main="jaccard+ward.D",
           border_color="grey60",
           #          border_color=NA,
           filename = "MADs_profiling_ordered.pdf", 
           width = 8, height = 8
 )
 #dev.off()
