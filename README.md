
# **Assessment Of Non -Coding Mutations In Endometriosis And Ovarian Cancer Histotypes**

This repository contains my master thesis work done in Spring 2024 at the University of Gothenburg. The final report can be read at this [Link](https://github.com/manuelrujano/Modig_thesis/blob/main/Rujano_Thesis_Masters_Degree.pdf).

Overview

The study design aims to detect and interpret non-coding variants in endometriosis and ovarian cancer. Sarek version 
3.2.3 was used for variant analysis on the FastQ files of whole exome
sequencing data (WES). The pipeline included preprocessing, variant calling, and annotation,
generating VCF files as output. 

Further, VCF files were processed using the **[Sei framework](https://github.com/manuelrujano), a deep-learning** pre-trained model to categorize
the sequences based on their regulatory activity. The steps are illustrated in Figure 1 below.


![Picture1](https://github.com/user-attachments/assets/46a8d75f-7e0d-4b79-97ff-99d4b36ecc7a)

Figure 1. The methods and flow of this study. 

# **Hotspots predicted by the Sei deep-learning model (Figure 2)**

![image](https://github.com/user-attachments/assets/cebb0e20-0f9f-42f0-976a-3b86f200e77a)

Figure 2. Number of variants per Sequence Class predicted by Sei. The bar graph categorizes the number of genetic variants across different sequence classes, with annotations grouped into categories such as CTCF Cohesin, Enhancer (E), Heterochromatin (HET), Low Signal (L), Polycomb (PC), Promoter (P), Transcription Factor (TF) and Transcription Sequence (TN). 





