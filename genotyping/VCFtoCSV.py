#!/usr/bin/env python 


def convertCSV(vcf,md):
	names = defaultdict()
	genotypeDict = {"0/0" : "0", 
					"0/1" : "1", 
					"1/1" : "2"}
	with open(vcf,'r') as vcfFile, open(os.path.splitext(vcf)[0] + ".tsv", 'w') as out:
		vcfData = [i.strip().split() for i in vcfFile.readlines() if not i.startswith("##")]
		metaData = []
		for x in os.listdir(md):
			if "targets" in x:
				with open(os.path.join(md,x), 'r') as file:
					metaData.extend([i.strip().split(",") for i in file.readlines()[1:]])
		for x in metaData:
			names[x[0]] = "_".join([x[0], x[1], x[4]])
		out.write("\t".join(["Strain"] + [names[i] for i in vcfData[0][9:]]) +"\n")
		for x in vcfData[1:]:
			genotypes = []
			genotypes.append("_".join([x[0],x[1]]))
			for i in range(9, len(x)):
				genotypes.append(genotypeDict.get(x[i][0:3], "-"))
			out.write("\t".join(genotypes) + "\n")

def main():
	ap = argparse.ArgumentParser()
	ap.add_argument(
		'--vcf',
		type = str,
		required = True,
		help = 'vcf file'
	)
	ap.add_argument(
		'--md',
		type = str,
		required = True,
		help = 'DArTseq metadata file'
	)
	convertCSV(ap.parse_args().vcf,
		       ap.parse_args().md
		      )

if __name__ == '__main__':
	import argparse,os
	from collections import defaultdict 
	main()