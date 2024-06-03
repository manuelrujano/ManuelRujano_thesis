library(openxlsx)
library(dplyr)
library(data.table)
library(ggplot2)
library(stringr)
library(forcats)

data1 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_endoseq.xlsx")
data2 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_twistexome.xlsx")



# Count of variants per sequence types annotated by SnpEff#######################

data_nc <- rbind(data1, data2)

summary_type <- data_nc %>%
  group_by(Type) %>%
  summarise(Count = n())

# Vector of new names corresponding to the original types
new_names <- c(
  "3_prime_UTR_variant" = "3' UTR Variant",
  "5_prime_UTR_variant" = "5' UTR Variant",
  "bidirectional_gene_fusion" = "Bidirectional Gene Fusion",
  "downstream_gene_variant" = "Downstream Gene Variant",
  "frameshift_variant&splice_acceptor_variant&splice_region_variant&intron_variant" = "Frameshift Variant, Splice Acceptor Variant, Splice Region Variant & Intron Variant",
  "intergenic_region" = "Intergenic Region",
  "intron_variant" = "Intron Variant",
  "splice_acceptor_variant&intron_variant" = "Splice Acceptor Variant & Intron Variant",
  "splice_acceptor_variant&splice_region_variant&intron_variant" = "Splice Acceptor Variant, Splice Region Variant & Intron Variant",
  "splice_donor_variant&intron_variant" = "Splice Donor Variant & Intron Variant",
  "splice_donor_variant&splice_region_variant&intron_variant" = "Splice Donor Variant, Splice Region Variant & Intron Variant",
  "splice_region_variant" = "Splice Region Variant",
  "splice_region_variant&intron_variant" = "Splice Region Variant & Intron Variant",
  "splice_region_variant&non_coding_transcript_exon_variant" = "Splice Region Variant & Non-coding Transcript Exon Variant",
  "upstream_gene_variant" = "Upstream Gene Variant"
)

# Replace the Type column with the new names
summary_type$Type <- new_names

# Calculate total count
total_count <- sum(summary_type$Count)

# Calculate percentage for each type
df <- summary_type %>%
  dplyr::mutate(Percentage = (Count / total_count) * 100)



# Variants bar plot with horizontal orientation and bars ordered by count
ggplot(summary_type, aes(x = Count, y = fct_reorder(Type, Count, .desc = FALSE))) +
  geom_bar(stat = "identity") +
  theme(axis.text.y = element_text(angle = 0, hjust = 1, vjust = 0.5),
        plot.title = element_text(hjust = 1.5),  # Adjust the bottom margin of the title
        plot.margin = margin(t = 20, r = 20, b = 20, l = 20)) +  # Adjust the top, right, bottom, and left margins
  labs(title = "Number of variants per sequence region annotated by SnpEff",
       x = "Number of variants",
       y = "Sequence region")




#Script to reproduce eQTL barplot

data_eq <- read.xlsx("C:/Users/manue/Downloads/eqtl10kb_file2.xlsx")

data_eq$Value <- gsub("\\..*", "", data_eq$gene)




# Create a new dataframe with counts
summary_df <- data_eq %>%
  group_by(Type) %>%
  summarize(matched = sum(Value == GeneID),
            not_matched = sum(Value != GeneID))



# Vector of new names corresponding to the original types
new_names <- c(
  "3_prime_UTR_variant" = "3' UTR Variant",
  "5_prime_UTR_variant" = "5' UTR Variant",
  "downstream_gene_variant" = "Downstream Gene Variant",
  "intron_variant" = "Intron Variant",
  "splice_region_variant" = "Splice Region Variant",
  "splice_region_variant&intron_variant" = "Splice Region Variant & Intron Variant",
  "upstream_gene_variant" = "Upstream Gene Variant"
)

summary_df$Type <- new_names

# Convert the summary dataframe to long format
summary_df_long <- tidyr::pivot_longer(summary_df, cols = c(matched, not_matched), names_to = "Gene_Match_SnpEff", values_to = "Count")

# Plot stacked bar plot
ggplot(summary_df_long, aes(x = Type, y = Count, fill = Gene_Match_SnpEff)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = c("matched" = "#1f77b4", "not_matched" = "#d62728")) +
  theme(        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Count of variants with eQTLs identified in the GTEx dataset",
       x = "Sequence type",
       y = "Count")





# Script to reproduce count of variants per sequence class annotated by Sei


data1 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_endoseq.xlsx")
data2 <- read.xlsx("C:/Users/manue/Downloads/latest_annotated_samples_twistexome.xlsx")


data_sei <- rbind(data1, data2)

summary_seq_class <- data_sei %>%
  group_by(Sequence.class) %>%
  summarise(Count = n())

# Remove dots from 'Sequence.class' column names
summary_seq_class$Sequence.class <- gsub("\\.", " ", summary_seq_class$Sequence.class)

# Define a function to categorize the sequence classes
categorize_group <- function(Sequence.class) {
  if (grepl("^CTCF", Sequence.class)) {
    return("CTCF Cohesin")
  } else if (grepl("^E", Sequence.class)) {
    return("Enhancer")
  } else if (grepl("^HET", Sequence.class)) {
    return("Heterochromatin")
  } else if (grepl("^L", Sequence.class)) {
    return("Low signal")
  } else if (grepl("^PC", Sequence.class)) {
    return("Polycomb")
  } else if (grepl("^P", Sequence.class)) {
    return("Promoter")
  } else if (grepl("^TF", Sequence.class)) {
    return("Transcription factor")
  } else if (grepl("^TN", Sequence.class)) {
    return("Transcription sequence")
  } else {
    return("Other")
  }
}

# Apply the function to categorize the sequence classes
df <- mutate(summary_seq_class, Group = sapply(Sequence.class, categorize_group))


# Sei bar plot with color Updated
ggplot(df, aes(x = Sequence.class, fill = Group, y = Count)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  theme(plot.margin = margin(t = 20, r = 20, b = 20, l = 20),
        axis.text.x = element_text(angle = 45, hjust = 1, size=10)) +
  labs(title = "Number of variants per sequence class annotated by Sei",
       x = "Sequence class",
       y = "Number of variants")
