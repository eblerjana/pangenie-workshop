=================
Exercises
=================

Prior to this workshop, make sure that you have read about pangenome representations required by PanGenie (see `Background <https://pangenie-workshop.readthedocs.io/en/latest/background.html>`_). In the following, we will assume that you are familiar with the *bubble VCF* and the *callset VCF* that can be used with PanGenie to genotype and decompose bubbles.


0. Preparation
===============

PanGenie is a tool build to run on a whole-genome dataset. In this workshop however, we will apply PanGenie to a small test dataset for demonstration purposes.
The dataset contains real data, but is restricted to a small region of human chromosome 5.

Tasks
------


| **0.1** The data to be used in this workshop is provided `here <https://github.com/eblerjana/pangenie-workshop/tree/main/data>`_.    
| **0.2** Inspect the files and determine which file corresponds to the *bubble VCF* and which one to the *callset VCF*.


1. Inspecting the input data
==============================

First, we are going to familiarize ourselves with the data files.
**Note:** the commandline tool `bcftools <https://samtools.github.io/bcftools/bcftools.html>`_ can be useful here, especially subcommands like `view` or `query`.

Tasks
------

| **1.1.** How many bubbles are in the underlying pangenome graph?
| **1.2.** How many variant alleles are in the pangenome? 
| **1.3.** How many haplotype paths are in the pangenome graph?


2. Running PanGenie
=====================

Our dataset contains read data for three human individuals: NA19191,NA19189 and NA19190. We now want to genotype all three of them using PanGenie. 

**Note:** for this workshop, please add commandline parameter `-e 100000` to all PanGenie commands to save RAM. Per default, PanGenie initializes space for a whole genome dataset, however, here, we are only dealing with a small test dataset. 

| **2.1.** Create the PanGenie index structure for our dataset. Make sure which VCF file to use for this.
| **2.2.** Genotype all three samples using the created index and the sample' sequencing data. Make sure to store the log output of the PanGenie command.
| **2.3.** For all three samples, convert bubble genotypes to variant genotypes using the `convert-to-biallelic.py` script.
| **2.4.** Inspect the log output of the commands run in 2.2. Which average k-mer coverages were computed by PanGenie for the three samples?
| **2.5.** Combine the VCFs resulting from 2.3 into a single VCF using `bcftools merge`.


3. Analyzing the genotypes
===========================

The three individuals that we genotyped are related: NA19191 is the child of NA19189 (father) and NA19190 (mother). In this section we will analyze the genotypes further. One particularly interesting variant is the one with ID *chr5-50300172-INS->157412165>157412166>157412167-186*. This variant is located in an ENCODE enhancer for B cell lymphomas and is associated with reduced expression of the immunoglobulin superfamily gene embigin (EMB), as reported by the `HGSVC <https://www.science.org/doi/10.1126/science.abf7117>`_.

| **3.1.** Check the genotypes of variant *chr5-50300172-INS->157412165>157412166>157412167-186* reported for all three individuals with PanGenie. From which parent was the variant inherited to the child?
| **3.2.** Check the mendelian consistency for all variants (hint: you can use the command `bcftools +mendelian2`). How many variants are mendelian consistent? How many mendelian errors are there?
