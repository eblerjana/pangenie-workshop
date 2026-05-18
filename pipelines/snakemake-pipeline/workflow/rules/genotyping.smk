
rule genotyping_pangenie_prepare_panel:
	"""
	Prepare (uncompressed) PanGenie input panel.
	"""
	input:
		vcf = PANEL_MULTI
	output:
		temp("{results}/panel-multi.vcf")
	shell:
		"""
		gunzip -c {input} > {output}
		"""


rule genotyping_pangenie_index:
	"""
	Create index for PanGenie.
	"""
	input:
		vcf = "{results}/panel-multi.vcf",
		fasta = REFERENCE,
	output:
		directory("{results}/pangenie/index/")
	log:
		"{results}/pangenie/index.log"
#	resources:
#		mem_mb = 50000,
#		walltime = "2:00:00"
	threads: 1
	params:
		out_prefix = "{results}/pangenie/index/index"
	benchmark:
		"{results}/pangenie/index.benchmark.txt"
	conda:
		"../envs/genotyping.yml"
	shell:
		"""
		mkdir {output}
		PanGenie-index -v {input.vcf} -r {input.fasta} -o {params.out_prefix} -t {threads} -e 100000  &> {log}
		"""


rule genotyping_pangenie_genotype_sampling:
	"""
	Run genotyping using sampling.
	"""
	input:
		reads = lambda wildcards: READS[wildcards.sample],
		index = "{results}/pangenie/index/"
	output:
		temp("{results}/pangenie/{sample}_pangenie_multi_genotyping.vcf")
	log:
		"{results}/pangenie/{sample}_pangenie_multi_genotyping.log"
#	resources:
#		mem_mb = 20000,
#		walltime = "1:00:00"
	params:
		index = "{results}/pangenie/index/index",
		out_prefix = "{results}/pangenie/{sample}_pangenie_multi",
	benchmark:
		"{results}/pangenie/{sample}_pangenie.benchmark.txt"
	threads:
		1
	conda:
		"../envs/genotyping.yml"
	shell:
		"""
		PanGenie -f {params.index} -i <(cat {input.reads}) -o {params.out_prefix} -t {threads} -j {threads} -s {wildcards.sample} -e 100000 &> {log}
		"""


rule genotyping_convert_genotypes_to_biallelic:
	"""
	Convert genotyped VCF to biallelic representation.
	"""
	input:
		vcf = "{results}/pangenie/{sample}_pangenie_multi_genotyping.vcf",
		biallelic = PANEL_BI
	output:
		bi = "{results}/pangenie/{sample}_pangenie_bi_genotyping.vcf.gz",
		bi_tbi = "{results}/pangenie/{sample}_pangenie_bi_genotyping.vcf.gz.tbi"
	conda:
		"../envs/bcftools.yml"
#	resources:
#		mem_mb=30000
	benchmark:
		"{results}/pangenie/{sample}_pangenie_bi_genotyping.benchmark.txt"
	shell:
		"""
		cat {input.vcf} | python3 workflow/scripts/convert-to-biallelic.py {input.biallelic} | bgzip > {output.bi}
		tabix -p vcf {output.bi}
		"""


rule genotyping_merge_vcfs:
	"""
	Merges the single-sample VCFs into one multi-sample VCF.
	"""
	input:
		expand("{{results}}/pangenie/{sample}_pangenie_bi_genotyping.vcf.gz", sample = SAMPLES)
	output:
		"{results}/pangenie/merged-genotypes_bi.vcf.gz"
	conda:
		"../envs/bcftools.yml"
	benchmark:
		"{results}/pangenie/all-samples_bi_genotyping.benchmark.txt"
	shell:
		"""
		bcftools merge {input} -Oz -o {output}
		tabix -p vcf {output}
		"""
