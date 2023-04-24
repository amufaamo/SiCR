# SiCR: Web Application for Single Cell Repertoire Analysis
## 1. Introduction
SiCR is web application specialized for single cell repertoire analysis. 
## 2. Install SiCR
### 2.1 Install R and R studio
If your PC (Windows, Mac, Linux) does not have R and R studio, please install these.
https://posit.co/download/rstudio-desktop/
### 2.2 Install R library packages.
SiCR uses following libraries, so please install using this command
```R
install.packages(c('ggsci', ‘RColorBrewer', 'tidyverse', 'Seurat', 'shiny', 'HGNChelper', 'alakazam', 'dowser'))
```
### 2.2 Download SiCR command

Download SiCR's docker image.

```bash
 # Download the docker image:
 docker pull 〇〇
```
## 3. How to use
SiCR uses outputs generated by celllranger of 10x Genomics. 
When you have fastq files generated by 10x Genomics Chromium Immune Profiling system, please run cellranger first, then upload the output files to SiCR.
### 3.1 Cellranger

Run ```cellranger multi```. 
```bash
cellranger multi --id=YOUR_ID --csv=YOUR_CSV 
```
If you have several samples, please run cellranger multi for each samples, then merge by using ```cellranger aggr```
```bash
cellranger aggr --id=pre_post_vac_aggr --csv=aggr.csv
```

Please refer [cellranger website](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger) more details. For ```cellranger aggr```, please refer [this website](https://support.10xgenomics.com/single-cell-vdj/software/pipelines/latest/using/aggr)

#### 3.2 Run SiCR using cellranger outputs
For running SiCR, we need maximum three files generated by cellranger multi.
1. **filtered_feature_bc_matrix.h5** (mandatory)
<p>This is a count file written in hdf5 format. This file exists in YOUR_ID/outs/count directory

2. **filtered_contig_annotations.csv** for TCR (optional)
<p>When you have data for TCR, please find this file. This file exists in YOUR_ID/outs/vdj_t directory

3. **filtered_contig_annotations.csv** for BCR (optional)
<p>When you have data for BCR, please find this file. This file exists in YOUR_ID/outs/vdj_b directory




### 3.2 Multiple samples
#### 3.2.1 Cellranger
