library(openxlsx)
library(dplyr)
library(data.table)
library(ggplot2)
library(pheatmap)


setwd("C:/Users/manue/Downloads")

data1 <- read.xlsx("C:/Users/manue/Downloads/endoseq2/Merged_data_endoseq_filtered.xlsx")

data2 <- read.xlsx("C:/Users/manue/Downloads/exome2/Merged_data_exome_filtered.xlsx")

#OR

#data1 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_endoseq.xlsx")

#data2 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_twistexome.xlsx")


#Intersect variants

#Extract names and assign subgroups of histotypes for Endo-seq (A) dataset

names_endo_CCOC_A <- c("2E_vs_2N", "4E_vs_4N")
names_tumor_CCOC_A <- c("2O_vs_2N", "4O_vs_4N")
names_endo_EOC_A <- c("1E_vs_1N", "3E_vs_3N", "5E_vs_5N", "6E_vs_6N")
names_tumor_EOC_A <- c("1O_vs_1N", "3O_vs_3N", "5O_vs_5N", "6O_vs_6N")

#Same step for Synchron-seq (B)

names_endo_CCOC_B <- c("2A_vs_2C", "3A_vs_3C")
names_tumor_CCOC_B <- c("2B_vs_2C", "3B_vs_3C")
names_endo_EOC_B<- c("9A_vs_9C")
names_tumor_EOC_B <- c("9B_vs_9C")

#Endo-seq subgroup

subgroup_endo_CCOC_A <- data1[data1$Sample %in% names_endo_CCOC_A, ]
subgroup_tumor_CCOC_A <- data1[data1$Sample %in% names_tumor_CCOC_A, ]
subgroup_endo_EOC_A <- data1[data1$Sample %in% names_endo_EOC_A, ]
subgroup_tumor_EOC_A <- data1[data1$Sample %in% names_tumor_EOC_A, ]

#Synchron-seq subgroup

subgroup_endo_CCOC_B <- data2[data2$Sample %in% names_endo_CCOC_B, ]
subgroup_tumor_CCOC_B <- data2[data2$Sample %in% names_tumor_CCOC_B, ]
subgroup_endo_EOC_B <- data2[data2$Sample %in% names_endo_EOC_B, ]
subgroup_tumor_EOC_B <- data2[data2$Sample %in% names_tumor_EOC_B, ]

# Define the data for the sets
variants_endo_CCOC_A <- subgroup_endo_CCOC_A$Variant
variants_tumor_CCOC_A <- subgroup_tumor_CCOC_A$Variant
variants_endo_EOC_A <- subgroup_endo_EOC_A$Variant
variants_tumor_EOC_A <- subgroup_tumor_EOC_A$Variant

# Define the data for the sets
variants_endo_CCOC_B <- subgroup_endo_CCOC_B$Variant
variants_tumor_CCOC_B <- subgroup_tumor_CCOC_B$Variant
variants_endo_EOC_B <- subgroup_endo_EOC_B$Variant
variants_tumor_EOC_B <- subgroup_tumor_EOC_B$Variant

# Calculate the intersections in OE and OC
intersection_endoseq_OE <- intersect(variants_endo_CCOC_A, variants_endo_EOC_A)
intersection_endoseq_OC <- intersect(variants_tumor_CCOC_A, variants_tumor_EOC_A)

# Calculate the intersections in OE and OC
intersection_synchron_OE <- intersect(variants_endo_CCOC_B, variants_endo_EOC_B)
intersection_synchron_OC <- intersect(variants_tumor_CCOC_B, variants_tumor_EOC_B)

intersection_all_endoseq <- intersect(intersection_endoseq_OE, intersection_endoseq_OC)

intersection_all_synchron <- intersect(intersection_synchron_OE, intersection_synchron_OC)

# Display the overlapping variants per groups
list(
  Intersection_endoseq_OE = intersection_endoseq_OE,
  Intersection_endoseq_OC = intersection_endoseq_OC,
  Intersection_synchron_OE = intersection_synchron_OE,
  Intersection_synchron_OC = intersection_synchron_OC,
  Intersection_all_endoseq = intersection_all_endoseq,
  Intersection_all_synchron = intersection_all_synchron
)




#Heatmap code



data <- rbind(data1, data2)


# Calculate the number of unique values in each column
num_unique_variants <- length(unique(data$Variant))
num_unique_samples <- length(unique(data$Sample))

sum(is.na(data$Sample))
sum(is.na(data$Variant))

#Number of samples per variants
ContingTableVariantsSamples <- apply(table(data$Variant, data$Sample), 1,
                                     function(x){ sum(x != 0)})

moreThan3 <- names(ContingTableVariantsSamples[which(ContingTableVariantsSamples > 3)])[-1]

VariantSampleDF <- data.frame(
  matrix(c(table(data$Variant, data$Sample)[moreThan3, ]),
         nrow = nrow(table(data$Variant, data$Sample)[moreThan3, ]),
         ncol = ncol(table(data$Variant, data$Sample)[moreThan3, ])),
  SamplesWithVariant = ContingTableVariantsSamples[which(ContingTableVariantsSamples > 3)][-1])
colnames(VariantSampleDF) <- c(colnames(table(data$Variant, data$Sample)), "SamplesWithVariant")
#write.xlsx(VariantSampleDF, file = "C:/Users/manue/Downloads/Morethan3.xlsx",
#           row.names = TRUE)

# Remove the last column (the total) before plotting 
heatmap_data <- VariantSampleDF[, -ncol(VariantSampleDF)]



# Function to replace cell values in geneSampleDF with corresponding values from data$Freq.ALT.tumor
fillCells <- function(x) {
  variant <- rownames(heatmap_data)[x[1]]
  sample <- colnames(heatmap_data)[x[2]]
  value <- data$Freq.ALT.tumor[data$Variant == variant & data$Sample == sample]
  ifelse(length(value) == 0, 0, value)
}


# Apply the function to each cell of VariantSampleDF
SampleDF <- apply(expand.grid(1:nrow(heatmap_data), 1:ncol(heatmap_data)), 1, fillCells)

# Convert geneSampleDF to data frame
VariantSampleDF1 <- as.data.frame(matrix(unlist(SampleDF), nrow = nrow(heatmap_data)))

VariantSampleDF1[is.na(VariantSampleDF1)] <- 0

# Replace row and column names
rownames(VariantSampleDF1) <- rownames(heatmap_data)
colnames(VariantSampleDF1) <- colnames(heatmap_data)


# Define a color palette
my_palette <- colorRampPalette(c("#132B43", "#56B1F7", "#FFFFFF", "#FFA07A", "#A30000"))(100)


# Original sample names

original_names <- c("1E_vs_1N", "1O_vs_1N", "2A_vs_2C", "2B_vs_2C", "2E_vs_2N", "2O_vs_2N", "3A_vs_3C", 
                    "3B_vs_3C", "3E_vs_3N", "3O_vs_3N", "4E_vs_4N", "4O_vs_4N", "5E_vs_5N", "5O_vs_5N",
                    "6B_vs_6C", "6E_vs_6N", "6O_vs_6N", "8B_vs_8C", "9A_vs_9C", "9B_vs_9C")

newnames <- c("OE-1A", "OC-E-1A", "OE-2B", "OC-CC-2B",  "OE-2A", "OC-CC-2A", "OE-3B", "OC-CC-3B", 
              "OE-3A",  "OC-E-3A","OE-4A", "OC-CC-4A", "OE-5A", "OC-E-5A", "OC-E-6B", "OE-6A",
              "OC-E-6A", "OC-E-8B", "OE-9B", "OC-E-9B")


# Indices of original names in the dataframe
indices <- match(original_names, colnames(VariantSampleDF1))

# Replace original names with new names in the dataframe
colnames(VariantSampleDF1)[indices] <- newnames


# Vector indicating the group color for each sample
sample_names <- colnames(VariantSampleDF1)
groups1 <- ifelse(sample_names %in% c("OE-1A", "OE-2B", "OE-2A", "OE-3B", "OE-3A",  
                                      "OE-4A", "OE-5A", "OE-6A", "OE-9B"),
                  "Endo", 
                  ifelse(sample_names %in% c("OC-E-1A", "OC-CC-2B", "OC-CC-2A","OC-CC-3B", 
                                             "OC-E-3A", "OC-CC-4A", "OC-E-5A", "OC-E-6B",
                                             "OC-E-6A", "OC-E-8B", "OC-E-9B"),
                         "Tumor",
                         "NA"))

# dataframe for annotation
annotation_df <- data.frame(
  Group = groups1,
  row.names = sample_names
)


# Create heatmap
heatmap_results <- pheatmap(as.matrix(VariantSampleDF1),
                            color = my_palette,
                            clustering_method = "single",
                            clustering_distance_rows = "binary",
                            clustering_distance_cols = "binary",
                            legend = TRUE,
                            legend_fill = my_palette,
                            main = "Mutation profile of endometriosis and EAOC",
                            fontsize = 9,
                            cellwidth = 15,
                            annotation_col = annotation_df,
                            annotation_colors = list(Group = c("Endo" = "#FFD700", "Tumor" = "#008000")),)

