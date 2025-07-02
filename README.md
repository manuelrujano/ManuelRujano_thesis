
# **Assessment Of Non -Coding Mutations In Endometriosis And Ovarian Cancer Histotypes**

This repository contains my master thesis work done in Spring 2024 at the University of Gothenburg. The final report can be read at this [Link](https://github.com/manuelrujano)

Overview
The study design aims to detect and interpret non-coding variants in cancer. Sarek version 
3.2.3 was used for variant analysis on the FastQ files of whole exome
sequencing data (WES). The pipeline included preprocessing, variant calling, and annotation,
generating VCF files as output. These were merged and filtered to identify somatic variants. The
steps described previously were performed in a Red Hat Enterprise Linux 8.3 secured server
provided by Gothenburg University (GU). 

Further, VCF files were processed using the Sei framework, a deep-learning pre-trained model to categorize
the sequences based on their regulatory activity. The steps are illustrated in the figure below.

![Picture1](https://github.com/user-attachments/assets/46a8d75f-7e0d-4b79-97ff-99d4b36ecc7a)

Once obtained the files from the merging and filtering step, these scripts can be used to reproduce the barplots and the heatmap.




