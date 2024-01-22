#This is the one that comes after the R code

# Load the Sei_data.xlsx file
sei_data_filepath = '/content/drive/MyDrive/BimaProject/Modig1/Test3/score_extraction.xlsx'  # Provide the path to your Sei_data.xlsx file
sei_data_df = pd.read_excel(sei_data_filepath, sheet_name='Sheet 1')

# Load the previously generated file.tsv
file_tsv_filepath = '/content/drive/MyDrive/BimaProject/Modig1/Test3/file.tsv'  # Provide the path to your file.tsv
file_tsv_df = pd.read_csv(file_tsv_filepath, sep='\t')

# Merge the two dataframes based on chromosome, position, reference allele, and alternate allele
merged_df = pd.merge(sei_data_df, file_tsv_df, on=['chrom', 'pos', 'ref', 'alt'], how='inner')

# Drop duplicates based on the specified columns
merged_df = merged_df.drop_duplicates(subset=['chrom', 'pos', 'ref', 'alt', 'gene'])

# Save the matching variants to a new output TSV file
output_matched_filepath = '/content/drive/MyDrive/BimaProject/Modig1/Test3/matched_file2.tsv'  # Provide the desired path for the output file
merged_df.to_csv(output_matched_filepath, sep='\t', index=False, columns=['chrom', 'pos', 'ref', 'alt', 'gene','Sequence class scores','Sequence class'])
