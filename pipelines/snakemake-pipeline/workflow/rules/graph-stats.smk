rule graph_get_stats:
	input:
		bubbles = PANEL_MULTI,
		variants = PANEL_BI
	output:
		"{results}/graph-stats/graph-statistics.txt"
	conda:
		"../envs/bcftools.yml"
	shell:
		"""
		bcftools view -H {input.bubbles} | wc -l > {output}
		bcftools view -H {input.variants} | wc -l >> {output}
		bcftools query -l {input.bubbles} | wc -l | awk \'{{print $1 * 2}}\' >> {output}
		"""
