#!/usr/bin/env python 

def chrSites(genome):
	from collections import defaultdict
	genomeDict = defaultdict(int)
	counter = 0
	with open(genome, 'r') as g:
		for x in g:
			x = x.strip()
			if x.startswith(">"):
				if counter != 0:
					genomeDict[x[1:]] = counter + 1
					continue 
				genomeDict[x[1:]] = 1
				continue
			counter += len(x)
	return genomeDict

def createTable(vcf,ref):
	results = []
	dataDict = chrSites(ref)
	with open(vcf, 'r') as fi, open(os.path.splitext(vcf)[0] + '_CMplot_table.txt', 'w') as out:
		data = [x.strip().split() for x in fi.readlines() if not x.startswith('##')]
		for i,c in enumerate(data[0][9:], start = 9):
			for x in data[1:]:
				if x[i].split(":")[0][0] == "1" or x[i].split(":")[0][2] == "1":
					results.append([x[0],c,str(int(dataDict[x[0]]) + int(x[1]))])
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
		'--reference',
		type = str,
		required = True,
		help = 'ref genome'
	)
	createTable(
		ap.parse_args().vcf,
		ap.parse_args().reference
	)

if __name__ == '__main__':
	import os,argparse
	main()