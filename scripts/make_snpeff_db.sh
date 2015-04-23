##Beginning commands for making a snpEff database
cd /home/bioinfo/Software/snpEff
mkdir data
cd data
mkdir SL2.40ch04
cd SL2.40ch04
cp ~/Desktop/ch4_demo_dataset/annotation/ITAG2.3_gene_models_ch4.gtf genes.gtf
cp ~/Desktop/ch4_demo_dataset/bwt2_index/SL2.40ch04.fa sequences.fa
cd /home/bioinfo/Software/snpEff
cd ~/Desktop/ch4_demo_dataset_backup

##Edit configuration file, then run snpEff build (see slides)