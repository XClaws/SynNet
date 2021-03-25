import re
import sys
#print ("usage: python DeleteRecords.py DB_file(whole-network) ID_file(Species-index-to-delete) OUT_file")
print ("usage: python FindRecords.py DB_file(whole-network) ID_file(GeneList) OUT_file")

filenames=sys.argv

#filea = open('Downloads/fileA.txt')
#fileb = open('Downloads/fileB.txt')

filea = open(filenames[1],'r')
fileb = open(filenames[2],'r')
output = open(filenames[3], 'w')

bad_words = set(line.strip() for line in fileb)
splitter = re.compile("\s")

for line in filea:
    line_words = set(splitter.split(line))
    if bad_words.intersection(line_words):
        output.write(line)

output.close()
