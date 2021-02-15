setwd('./')
setwd('~/Desktop/VesicSymb_Evolution/mauve_alignments/')
library(ape)
library(dplyr)
########## Tree based on LCBs ################
df=read.table('ALL_LCBs.txt',header=T,sep='\t')
df
ngenomes=ncol(df)
df$count=ngenomes-rowSums(df==0)
df=df[df$count>1,]
df$avg=rowMeans(df[,1:length(df)-1])
df=df[df$avg>100,]
nrow(df)
head(df)

plot(nj(dist(t(df[,1:ngenomes]),method='euclid')),'u') ## 00 count as similarity

tree=nj(dist(t(df[,1:ngenomes]),method='binary')) ## Jaccard distance
plot(tree,"u")

## rooted tree

out = 2
nj.gen <- function(xx){root(phy = nj(dist(xx,method='binary')), outgroup = out,
                                resolve.root = F)}

lcb.nj <- nj.gen(t(df[,1:ngenomes]))
plot(lcb.nj)

# run bootstraps 

lcb.nj.bs <- boot.phylo(phy = lcb.nj, x = t(df[,1:ngenomes]), FUN = nj.gen, B=10000)/100

# Add bootstraps to PHYLO object
lcb.nj$node.label <- lcb.nj.bs
# Check that iw worked by printing the PHYLO object. There should be some text that says "Node labels:" proceeded by a list of the bootstrap values.
# Write out as Newick format
print(lcb.nj)

plot(lcb.nj)


# write.tree(lcb.nj, file = "LCBs_all_presenceabsence.tree")
write.tree(lcb.nj, file = "LCBs_100_presenceabsence.tree")

############## Tree based on genes ######################
out = 2
nj.gen <- function(xx){root(phy = nj(dist(xx,method='binary')), outgroup = out,
                            resolve.root = TRUE)}


df=read.csv2('Orthology_id35cov51_nopseudo.txt',header=T,sep='\t',row.names = 1, na.strings = "")
df=data.frame(lapply(df, function(x) as.integer(x!="0")))
df= df %>% mutate_all(~replace(., is.na(.), 0))
df %>% tail


gene.nj <- nj.gen(t(df[,1:ngenomes]))
plot(gene.nj)

gene.nj.bs <- boot.phylo(phy = gene.nj, x = t(df[,1:ngenomes]), FUN = nj.gen, B=10000)/100

# Add bootstraps to PHYLO object
gene.nj$node.label <- gene.nj.bs
# Check that iw worked by printing the PHYLO object. There should be some text that says "Node labels:" proceeded by a list of the bootstrap values.
# Write out as Newick format
write.tree(gene.nj, file = "../dowstream_analyses_and_data/genes_presenceabsence.tree")

d<-df[,1:ngenomes]
d[d>0]<-1
head(d)
heatmap(as.matrix(dist(t(d),method='euclid')))
plot(nj(dist(t(df[,1:ngenomes]),method='euclid')),'u')
plot(nj(dist(t(d),method='binary')),'u')
