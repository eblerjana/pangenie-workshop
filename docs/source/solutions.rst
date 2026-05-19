=================
Solutions
=================

Prior to this workshop, make sure that you have read about pangenome representations required by PanGenie (see `Background <https://pangenie-workshop.readthedocs.io/en/latest/background.html>`_). In the following, we will assume that you are familiar with the *bubble VCF* and the *callset VCF* that can be used with PanGenie to genotype and decompose bubbles.


0. Preparation
===============

PanGenie is a tool build to run on a whole-genome dataset. In this workshop however, we will apply PanGenie to a small test dataset for demonstration purposes.
The dataset contains real data, but is restricted to a small region of human chromosome 5.

Tasks
------


| **0.2 Inspect the files and determine which file corresponds to the *bubble VCF* and which one to the *callset VCF*.**

- Bubble VCF: ``panel_multi_chr5:50200000-50400000.vcf.gz``
- Callset VCF: ``panel_bi_chr5:50200000-50400000.vcf.gz``
- Reference genome: ``reference_chr5:50200000-50400000.fasta``
- Reads:
        - NA19189: ``NA19189_chr5:50200000-50400000.fasta``
        - NA19190: ``NA19190_chr5:50200000-50400000.fasta``
        - NA19191: ``NA19191_chr5:50200000-50400000.fasta``





1. Inspecting the input data
==============================

First, we are going to familiarize ourselves with the data files.
**Note:** the commandline tool `bcftools <https://samtools.github.io/bcftools/bcftools.html>`_ can be useful here, especially subcommands like `view` or `query`.

Tasks
------

| **1.1. How many bubbles are in the underlying pangenome graph?**

We can determine the number of bubbles in the graph by simply counting the number of records in the *bubble VCF*, e.g. using this command::

    bcftools view -H panel_multi_chr5:50200000-50400000.vcf.gz | wc -l

which will tell us that the number of bubbles is: 3924.




| **1.2. How many variant alleles are in the pangenome?**

The number of variant alleles can be determined by counting the number of records in the *callset VCF*, using the same command as for 1.1::

    bcftools view -H panel_bi_chr5:50200000-50400000.vcf.gz | wc -l

This returns: 5163.


| **1.3. How many haplotype paths are in the pangenome graph?**

The number of haplotypes in the graph can be determined from the sample columns present in the *bubble* and *callset* VCFs (both contain the same samples). Since we are dealing with diploid samples, we can simply count the number of samples in the VCF and multiply the resulting number by two. One way to do this is by using the command:: 
    
    bcftools query -l panel_multi_chr5:50200000-50400000.vcf.gz | wc -l | awk '{print $1 * 2}'

The number of haplotype paths is: 462.


2. Running PanGenie
=====================

Our dataset contains read data for three human individuals: NA19191,NA19189 and NA19190. We now want to genotype all three of them using PanGenie.

**Note:** for this workshop, plese add commandline parameter `-e 100000` to all PanGenie commands to save RAM. Per default, PanGenie initializes space for a whole genome dataset, however, here, we are only dealing with a small test dataset.

| **2.1. Create the PanGenie index structure for our dataset. Make sure which VCF file to use for this.**

We need to use the *bubble VCF* to generate an index with PanGenie. The following command needs to be run::

    PanGenie-index -v panel_multi_chr5:50200000-50400000.vcf -r reference_chr5:50200000-50400000.fasta -o genotypes -t 1 -e 100000 &> indexing.log

Note: given that our dataset is very small, we can run PanGenie with a single thread (``-t 1``) and parameter ``-e 100000``. For a real, whole-genome data set (PanGenie's use case), remove the ``-e`` parameter and increase the number of threads if possible.


| **2.2. Genotype all three samples using the created index and the sample' sequencing data. Make sure to store the log output of the PanGenie command.**

Using the index previously computed, we can now genotype all three samples using their respective read data with the commands below::

    PanGenie -f genotypes -i <(cat NA19189_chr5:50200000-50400000.fasta) -o NA19189_pangenie_multi -t 1 -j 1 -s NA19189 -e 100000 &> pangenie_NA19189.log
    PanGenie -f genotypes -i <(cat NA19190_chr5:50200000-50400000.fasta) -o NA19190_pangenie_multi -t 1 -j 1 -s NA19190 -e 100000 &> pangenie_NA19190.log
    PanGenie -f genotypes -i <(cat NA19191_chr5:50200000-50400000.fasta) -o NA19191_pangenie_multi -t 1 -j 1 -s NA19191 -e 100000 &> pangenie_NA19191.log

Note: given that our dataset is very small, we can run PanGenie with a single thread (``-t 1`` and ``-j ``) and parameter ``-e 100000``. For a real, whole-genome data set (PanGenie's use case), remove the ``-e`` parameter and increase the number of threads if possible.


| **2.3. For all three samples, convert bubble genotypes to variant genotypes using the convert-to-biallelic.py script.**

Using the *callset VCF* and the genotype VCFs we generated in the previous task for all three samples, we can convert the bubble genotypes to variant genotypes with the commands shown below::

   cat NA19189_pangenie_multi_genotyping.vcf | python3 convert-to-biallelic.py panel_multi_chr5:50200000-50400000.vcf.gz | bgzip > NA19189_pangenie_bi_genotyping.vcf.gz
   tabix -p vcf NA19189_pangenie_bi_genotyping.vcf.gz

   cat NA19190_pangenie_multi_genotyping.vcf | python3 convert-to-biallelic.py panel_multi_chr5:50200000-50400000.vcf.gz | bgzip > NA19190_pangenie_bi_genotyping.vcf.gz
   tabix -p vcf NA19190_pangenie_bi_genotyping.vcf.gz

   cat NA19191_pangenie_multi_genotyping.vcf | python3 convert-to-biallelic.py panel_multi_chr5:50200000-50400000.vcf.gz | bgzip > NA19191_pangenie_bi_genotyping.vcf.gz
   tabix -p vcf NA19191_pangenie_bi_genotyping.vcf.gz



| **2.4. Inspect the log output of the commands run in 2.2. Which average k-mer coverages were computed by PanGenie for the three samples?**

We have stored the log outputs in files ``pangenie_<sample>.log`` (see 2.2.). These files contain a line starting with "Computed kmer abundance peak:" which provides the average k-mer coverage estimated for the respective sample.

We get the following numbers:

- NA19189: 25
- NA19190: 31
- NA19191: 26



| **2.5. Combine the VCFs resulting from 2.3 into a single VCF using bcftools merge.**

We can use the following command to combine all three output VCFs into a single one::

                bcftools merge NA19189_pangenie_bi_genotyping.vcf.gz NA19190_pangenie_bi_genotyping.vcf.gz NA19191_pangenie_bi_genotyping.vcf.gz -Oz -o merged-genotypes_bi.vcf.gz
                tabix -p vcf merged-genotypes_bi.vcf.gz



3. Analyzing the genotypes
===========================

The three individuals that we genotyped are related: NA19191 is the child of NA19189 (father) and NA19190 (mother). In this section we will analyze the genotypes further. One particularly interesting variant is *chr5-50300172-INS->157412165>157412166>157412167-186*. This variant is located in an ENCODE enhancer for B cell lymphomas and is associated with reduced expression of the immunoglobulin superfamily gene embigin (EMB), as reported by the `HGSVC <https://www.science.org/doi/10.1126/science.abf7117>`_.

| **3.1. Check the genotypes of variant chr5-50300172-INS->157412165>157412166>157412167-186 reported for all three individuals with PanGenie. From which parent was the variant inherited to the child?**

The variants in our VCFs are all assigned an ID in the INFO column of the VCF. All we need to do is to look for the ID in the VCF. The mother (NA19190) has genotype 1/1, the father (NA19189) has genotype 0/0 and the child is genotyped as 0/1. Therefore, the variant allele was inherited from the mother to the child.


| **3.2. Check the mendelian consistency for all variants (hint: you can use the command bcftools +mendelian2). How many variants are mendelian consistent? How many mendelian errors are there?**

There are 5160 mendelian consistent variant sites and one mendelian error. The erroneous variant is chr5-50221495-SNV->157406351>157406353>157406354-1. Two of the variants are not in the genotyped set because PanGenie ignores variants that are less than two times the k-mer size away from the start or end of the genotyped region.
