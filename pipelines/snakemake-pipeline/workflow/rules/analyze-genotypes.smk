
rule analyze_mendelian_consistency:
	input:
		vcf = "{results}/pangenie/merged-genotypes_bi.vcf.gz",
		ped = PED
	output:
		"{results}/analyze/mendelian-consistency.txt"
	conda:
		"../envs/bcftools.yml"
	shell:
		"""
#		bcftools +mendelian2 {input.vcf} -P {input.ped} &> {output}
		bcftools +mendelian {input.vcf} -T {input.ped} -c &> {output}
		"""
