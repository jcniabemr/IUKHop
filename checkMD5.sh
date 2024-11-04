#!/usr/bin/env bash
#SBATCH -J checkMD5
#SBATCH -p long,medium,short
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

#####Check that calculated MD5 sum for each downloaded file corresponds to the MD5 sum given by DArTseq
checkMD5(){
calculatedMD5=$(md5sum ${1} | awk '{print $1}')
md5=$(grep ${1} MD5SUMS | awk '{print $1}')
if  [[ ${calculatedMD5} != ${md5} ]]; then 
		echo "The sample ${sample} has an expected MD5 of ${md5} and the calculated MD5 was ${calculatedMD5}, re-downloading sample ...." 
		reDownloadData ${sample}
else
		echo "The sample ${sample} has an expected MD5 of ${md5} and the calcualted MD5 was ${calculatedMD5}, MD5 sums match, checking next sample."
		echo "Sample ${sample} has a calculated MD5 sum of ${calculatedMD5} and an expected MD5 sum of ${md5}, download successful" >> md5Log.txt
fi
}

reDownloadData(){
echo "Removing corrupted download of ${1}"
rm ${1}
link=$(grep ${1} list_files.pl | grep -oP '(?<=href=").*(?=" )')
echo "Redownloading ${1}..."
wget --header 'Authorization: Bearer DISGuOwFbiawQ4efostRjldfchDgBwym2f06yhTV' ${link}
echo "Re-checking MD5 sum for ${1}"
checkMD5 ${1}
}

cat MD5SUMS	| while IFS=' ' read -r md5 sample; do
	echo "Checking sample ${sample}" 
	checkMD5 ${sample} 
done 
echo "All samples assessed and passed MD5 check" 