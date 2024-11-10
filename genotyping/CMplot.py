#!/usr/bin/env python 

def createTable(vcf, target):
	results = []
	with open(vcf, 'r') as fi, open(os.path.splitext(vcf)[0] + '_CMplot_table.txt', 'w') as out:
		data = [x.strip().split() for x in fi.readlines() if not x.startswith('##')]
		for i,c in enumerate(data[0][9:], start = 9):
			for x in data[1:]:
				if x[0] == target:
					if x[i].split(":")[0][0] == "1" or x[i].split(":")[0][2] == "1":
						results.append([x[0],c,x[1]])
		for e in sorted(results, key = lambda i: (int(i[1]), int(i[2]))):
			out.write("\t".join(e)+"\n")

def main():
	ap = argparse.ArgumentParser()
	ap.add_argument(
		'--vcf',
		type = str,
		required = True,
		help = 'vcf file'
	)
	ap.add_argument(
		'--target',
		type = str,
		required = True,
		help = 'target chrom'
	)
	createTable(
		ap.parse_args().vcf,
		ap.parse_args().target
	)

if __name__ == '__main__':
	import os,argparse
	main()