
rule analyze_mendelian_consistency:
	input:
		"{results}/pangenie/merged-genotypes_bi.vcf.gz"
	output:
		"{results}/analyze/mendelian-consistency.txt"
	conda:
		"../envs/bcftools.yml"
	shell:
		"""
		
		"""
