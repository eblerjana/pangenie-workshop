import sys


def parse_trios(triofile):
	trios = {}
	for line in open(triofile, 'r'):
		fields = line.strip().split()
		child = fields[0]
		father = fields[1]
		mother = fields[2]
		trios[child] = [father, mother]
	return trios

def mendelian_consistent(child_gt, father_gt, mother_gt):
	if ('.' in child_gt) or ('.' in father_gt) or ('.' in mother_gt):
		return 2
	else:
		assert child_gt in ["0/0", "1/0", "0/1", "1/1"]
		assert father_gt in ["0/0", "1/0", "0/1", "1/1"]
		assert mother_gt in ["0/0", "1/0", "0/1", "1/1"]

		child_alleles = child_gt.split('/')
		father_alleles = father_gt.split('/')
		mother_alleles = mother_gt.split('/')

		if (child_alleles[0] in father_alleles) and (child_alleles[1] in mother_alleles):
			return 0
		elif (child_alleles[0] in mother_alleles) and (child_alleles[1] in father_alleles):
			return 0
		else:
			return 1

trios = parse_trios(sys.argv[1])
samples = None

nr_consistent = 0
nr_errors = 0
nr_skipped = 0

for line in sys.stdin:
	if line.startswith('##'):
		continue
	fields = line.strip().split()
	if line.startswith('#'):
		samples = fields[9:]
		continue

	assert samples is not None
	gt_index = fields[8].split(':').index("GT")
	sample_to_genotype = {s : g.split(':')[gt_index] for s,g in zip(samples, fields[9:])}

	for trio in trios:
		mendelian_check = mendelian_consistent(sample_to_genotype[trio], sample_to_genotype[trios[trio][0]], sample_to_genotype[trios[trio][1]])
		if mendelian_check == 0:
			nr_consistent += 1
		elif mendelian_check == 1:
			nr_errors += 1
			print(fields[0], fields[1])
		elif mendelian_check == 2:
			nr_skipped += 1	

print('Consistent sites: ' + str(nr_consistent))
print('Mendelian errors: ' + str(nr_errors))
print('Skipped sites: ' + str(nr_skipped))
