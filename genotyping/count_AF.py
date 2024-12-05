#!/usr/bin/env python 


def filterAlleleFreq(vcf):
	with open(vcf, 'r') as infile, open(os.path.splitext(vcf)[0] + "_AF5.vcf", 'w') as out:
		out.write("".join([i for i in infile.readlines() if i.startswith("#")]))
		infile.seek(0)
		data = [x.strip().split() for x in infile.readlines() if not x.startswith("##")]
		alleleDict = defaultdict(lambda: defaultdict(int))
		genotypes = ["./.", "0/1", "1/1", "0/0"]
		for x in data[1:]:
			for i,c in enumerate(data[0][9:], start = 9):
				if x[i][0:3] not in genotypes:
					continue 
				if x[i][0] == "1" and x[i][2] == "1":
					alleleDict["_".join(x[0:2])]["Alt"] += 2
					continue 
				if x[i][0] == "0" and x[i][2] == "0":
					alleleDict["_".join(x[0:2])]["Ref"] += 2
					continue 
				if "1" in x[i][0:3]:
					alleleDict["_".join(x[0:2])]["Alt"] += 1
				if "0" in x[i][0:3]:
					alleleDict["_".join(x[0:2])]["Ref"] += 1
	
		for x in data[1:]:
			if alleleDict["_".join(x[0:2])]["Alt"]/(alleleDict["_".join(x[0:2])]["Ref"]+alleleDict["_".join(x[0:2])]["Alt"])*100 > 15:
				out.write("\t".join(x) + "\n")
			

def main():
	ap = argparse.ArgumentParser()
	ap.add_argument(
		'--vcf',
		type = str,
		required = True,
		help = 'vcf file'
	)
	filterAlleleFreq(ap.parse_args().vcf)

if __name__ == '__main__':
	import argparse,os
	from collections import defaultdict 
	main()