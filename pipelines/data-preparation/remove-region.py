import sys

for line in sys.stdin:
	if line.startswith(">"):
		print(line.strip().split(':')[0])
		continue
	print(line.strip())
