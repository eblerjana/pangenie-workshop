import sys

region = sys.argv[1]

start_coord = 0

if ':' in region:
	start_coord = int(region.split(':')[-1].split('-')[0])
	start_chrom = region.split(':')[0]

for line in sys.stdin:
	if line.startswith('#'):
		print(line.strip())
		continue
	fields = line.strip().split()
	fields[1] = str(int(fields[1]) - start_coord) 
	print('\t'.join(fields).strip())
