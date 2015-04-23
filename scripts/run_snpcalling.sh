##Shell script for running gatk and samtools
##Place in /home/bioinfo/Desktop/ch4_demo_dataset to use
##Must run run_tuxed.sh before used

#Step 1: find accepted_hits.bam files
mkdir snps
samtools merge - breaker/SRR404334/SRR404334_ch4_thout/accepted_hits.bam breaker/SRR404336/SRR404336_ch4_thout/accepted_hits.bam immature_fruit/SRR404331/SRR404331_ch4_thout/accepted_hits.bam immature_fruit/SRR404333/SRR404333_ch4_thout/accepted_hits.bam |samtools sort - snps/all_hits

#Mark duplicate reads
java -jar /home/bioinfo/Software/picard-tools-1.87/MarkDuplicates.jar INPUT=snps/all_hits.bam OUTPUT=snps/all_hits_md.bam REMOVE_DUPLICATES=FALSE VALIDATION_STRINGENCY=SILENT ASSUME_SORTED=TRUE METRICS_FILE=snps/markdups.metrics

#Add read groups
java -jar /home/bioinfo/Software/picard-tools-1.87/AddOrReplaceReadGroups.jar INPUT=snps/all_hits_md.bam OUTPUT=snps/all_hits_md_rg.bam SORT_ORDER=coordinate RGID=1 RGLB=1 RGPL=illumina RGPU=run RGSM=pimpi RGCN=sra RGDS=pimpi_fruit RGDT=0

#Create a sequence dictionary for the reference
java -jar /home/bioinfo/Software/picard-tools-1.87/CreateSequenceDictionary.jar REFERENCE=bwt2_index/SL2.40ch04.fa OUTPUT=bwt2_index/SL2.40ch04.dict

#Index the bam file
samtools index snps/all_hits_md_rg.bam

#Find targets for indel realignment
java -jar /home/bioinfo/Software/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /home/bioinfo/Desktop/ch4_demo_dataset/bwt2_index/SL2.40ch04.fa -I snps/all_hits_md_rg.bam -o snps/realign.intervals

#Realign targeted indels
java -jar /home/bioinfo/Software/GenomeAnalysisTK.jar -T IndelRealigner -R bwt2_index/SL2.40ch04.fa -I snps/all_hits_md_rg.bam -targetIntervals snps/realign.intervals -o snps/all_hits_md_rg_realn.bam

#Call SNPs with GATK haplotype caller
java -jar /home/bioinfo/Software/GenomeAnalysisTK.jar -T HaplotypeCaller -R bwt2_index/SL2.40ch04.fa -I snps/all_hits_md_rg_realn.bam -o snps/all_hits_hapcall.vcf

#Call SNPs with Samtools
samtools mpileup -C 50 -uf bwt2_index/SL2.40ch04.fa snps/all_hits_md_rg_realn.bam |bcftools view -bvcg - > snps/samtools_snp.bcf
bcftools view snps/samtools_snp.bcf |vcfutils.pl varFilter -D 100 > snps/samtools_snp_filt.vcf 

#Compare GATK and Samtools SNPs with combine variants
java -jar /home/bioinfo/Software/GenomeAnalysisTK.jar -T CombineVariants -R bwt2_index/SL2.40ch04.fa -o hapcall_vs_samtools_snps.vcf  --variant:hapcall all_hits_hapcall.vcf --variant:samtools filtered_var.vcf
