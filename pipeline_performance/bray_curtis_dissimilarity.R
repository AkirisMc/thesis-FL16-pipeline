rm(list=ls())

# loading required packages
# install.packages("vegan")
library(vegan)
library(readr)
library(ggplot2)


### Zymo mock community

# importing and processing the file with the read counts
zymo_abundance <- read_csv("Thesis/zymo_abundance.csv", col_types = cols(condition = col_skip()))
df_zymo_abundance <- as.data.frame(sapply(zymo_abundance, as.numeric))
rownames(df_zymo_abundance) <- c("Zymo mock community", "VSEARCH detected species", "Naive Bayes detected species")

# calculating the Bray-Curtis dissimilarity 
braycurtis_zymo <- vegdist(df_zymo_abundance, method = "bray")

# performing hierarchical clustering 
hc_zymo <- hclust(as.dist(braycurtis_zymo), method = "ward.D")

# generating the dendrogram plot based on Bray-Curtis dissimilarities
plot(hc_zymo)

# calculating Non-Metric Multidimensional Scaling (NMDS)
nmds_zymo <- metaMDS(braycurtis_zymo, trace = FALSE, autotransform = FALSE)

nmds_xy_zymo <- data.frame(nmds_zymo$points)
condition <- rownames(nmds_xy_zymo)

# generating the MDS plot based on Bray-Curtis dissimilarities 
ggplot(nmds_xy_zymo, aes(MDS1, MDS2, color = condition)) + geom_point(size = 2.5) +
  theme_bw() + ggtitle("Bray-Curtis MDS plot")



### HMP/BEI mock community

# importing and processing the file with the read counts
hmp_abundance <- read_csv("Thesis/HMPBEI_abundance.csv", col_types = cols(condition = col_skip()))
df_hmp_abundance <- as.data.frame(sapply(hmp_abundance, as.numeric))
rownames(df_hmp_abundance) <- c("HMP/BEI mock community", "VSEARCH detected species", "Naive Bayes detected species")

# calculating the Bray-Curtis dissimilarity 
braycurtis_hmp <- vegdist(df_hmp_abundance, method = "bray")

# performing hierarchical clustering 
hc_hmp <- hclust(as.dist(braycurtis_hmp), method = "ward.D")

# generating the dendrogram plot based on Bray-Curtis dissimilarities
plot(hc_hmp)

# calculating Non-Metric Multidimensional Scaling (NMDS)
nmds_hmp <- metaMDS(braycurtis_hmp, trace = FALSE, autotransform = FALSE)

nmds_xy_hmp <- data.frame(nmds_hmp$points)
condition <- rownames(nmds_xy_hmp)

# generating the MDS plot based on Bray-Curtis dissimilarities 
ggplot(nmds_xy_hmp, aes(MDS1, MDS2, color = condition)) + geom_point(size = 2.5) +
  theme_bw() + ggtitle("Bray-Curtis MDS plot")
