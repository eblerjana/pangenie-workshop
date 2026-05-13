=================
Exercises
=================

Prior to this workshop, make sure that you have read about pangenome representations required by PanGenie (see `Background <https://pangenie-workshop.readthedocs.io/en/latest/background.html>`_. In the following, we will assume that you are familiar with the *bubble VCF* and the *callset VCF* that can be used with PanGenie to genotype and decompose bubbles.


0. Preparation
===============

PanGenie is a tool build to run on a whole-genome dataset. In this workshop however, we will apply PanGenie to a small test dataset for demonstration purposes.
The dataset contains real data, but is restricted to a small region of human chromosome 5.

Tasks
------


| 0.1 Download the data from: XXXX.    
| 0.2 Create a folder called `data` and move the files to that folder.


1. Inspecting the input data
==============================

First, we are going to familiarize ourselves with the data files.
**Note:** the commandline tool `bcftools` can be useful here, especially subcommands like `view` or `query`.

Tasks
------

| 1.1. How many bubbles are in the underlying pangenome graph?
| 1.2. How many variant alleles are in the pangenome? 
| 1.3. How many haplotype paths are in the pangenome graph?


2. Running PanGenie
=====================

Our dataset contains read data for three individuals: XXX, XXX and XXX. We now want to genotype all three of them using PanGenie. 

**Note:** for this workshop, plese add commandline parameter `-e 100000` to all PanGenie commands to save RAM. Per default, PanGenie initializes space for a whole genome dataset, however, here, we are only dealing with a small test dataset. 

| 2.1. Create the PanGenie index structure for our dataset. Make sure which VCF file to use for this.
| 2.2. Genotype all three samples using the created index and the sample' sequencing data. Make sure to store the log output of the PanGenie command.
| 2.3. For all three samples, convert bubble genotypes to variant genotypes using the `convert-to-biallelic.py` script.
| 2.4. Inspect the log output of the commands run in 2.2. Which average k-mer coverages were computed by PanGenie for the three samples?
| 2.4. Combine the VCFs resulting from 2.3 into a single VCF using `bcftools merge`.


3. Analyzing the genotypes
===========================

The three samples that we genotyped are related: XXX and XXX are the parents of XXX. In this section we will analyze the samples genotypes further. One particularly interesting variant is XXX. This variant has previously been associated with XXX. 

| 3.1. How many variants have at least one missing genotype in any of the three samples?
| 3.2. Check the sample's genotypes for variant XXX. From which parent was it inherited to the child?
| 3.3. Check the mendelian consistency for all variants (hint: you can use the command `bcftools +mendelian2`). How many variants are mendelian consistent? How many mendelian errors are there?
