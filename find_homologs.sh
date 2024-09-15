
#Running BLAST with the query and subject files
#blastn -query "$1" -subject "$2" -outfmt "6" | awk '$3==100' > "$3"
#echo "Number of perfect matches: $(wc -l <"$3")"

#Changing file content
#echo "oops!"

#!/bin/bash

# Usage: ./find_homologs.sh <query file> <subject file> <output file>
# Example: ./find_homologs.sh query.faa subject.fna output.txt

if [ "$#" -ne 3 ]; then
    echo "Usage: ./find_homologs.sh <query file> <subject file> <output file>"
    exit 1
fi

query_file=$1
subject_file=$2
output_file=$3

# Perform BLAST search (tblastn: protein query, nucleotide subject)
blast_out="blast_results.txt"
tblastn -query "$query_file" -subject "$subject_file" -out "$blast_out" -outfmt "6 qseqid sseqid pident length qlen slen"

# Filter hits (pident > 30%, length > 90% of query length)
awk '$3 > 30 && $4 > 0.9 * $5' "$blast_out" > "$output_file"

# Count and print the number of matches
num_matches=$(wc -l < "$output_file")
echo "Number of matches identified: $num_matches"
