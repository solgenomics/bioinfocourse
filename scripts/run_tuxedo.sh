##Shell script for running tophat2 and cuffdiff
##Place in /home/bioinfo/Desktop/ch4_demo_dataset to use

#Step 1: run index the reference fasta file for faster match searching
bowtie2-build bwt2_index/SL2.40ch04.fa bwt2_index/SL2.40ch04

#Step 2: run tophat2 on first breaker fastq file
tophat2 -o breaker/SRR404334/SRR404334_ch4_thout --no-novel-juncs --no-coverage-search bwt2_index/SL2.40ch04 breaker/SRR404334/SRR404334_ch4.fq

#Step 3: run tophat2 on second breaker fastq file
tophat2 -o breaker/SRR404336/SRR404336_ch4_thout --no-novel-juncs --no-coverage-search bwt2_index/SL2.40ch04 breaker/SRR404336/SRR404336_ch4.fq

#Step 4: run tophat2 on first immature fruit fastq file
tophat2 -o immature_fruit/SRR404331/SRR404331_ch4_thout --no-novel-juncs --no-coverage-search bwt2_index/SL2.40ch04 immature_fruit/SRR404331/SRR404331_ch4.fq

#Step 5: run tophat2 on first immature fruit fastq file
tophat2 -o immature_fruit/SRR404333/SRR404333_ch4_thout --no-novel-juncs --no-coverage-search bwt2_index/SL2.40ch04 immature_fruit/SRR404333/SRR404333_ch4.fq

#Step 6: run cufflinks to find putatively differential expressed genes
cuffdiff -o cuffdiff_out -b bwt2_index/SL2.40ch04.fa -u annotation/ITAG2.3_gene_models_ch4.gtf  breaker/SRR404334/SRR404334_ch4_thout/accepted_hits.bam,breaker/SRR404336/SRR404336_ch4_thout/accepted_hits.bam immature_fruit/SRR404331/SRR404331_ch4_thout/accepted_hits.bam,immature_fruit/SRR404333/SRR404333_ch4_thout/accepted_hits.bam
