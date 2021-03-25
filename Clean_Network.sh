# Clean_Network.sh hmmer-genelist total-network

#REM this is used for generating subnetwork from a genelist
#REM in this case all the nodes are in integers.
#REM find subnetwork from the whole one, however there are some nodes and edge we don't want.
# grep -w -f "$1" $2 > $1.net
#REM if the network have nodes in number don't use findstr
#REM findstr /G:%arg1% AP2_net_num > %arg1%.net
#REM we extract all the nodes from the subnetwork

# This used for to delete nodes not belong to this gene family

cat $2|awk "{print \$1}" > nodelist1
cat $2|awk "{print \$2}" >> nodelist1
dos2unix nodelist1
sort nodelist1 | awk "!a[\$1]++" > subnetwork_nodelist
#REM also sort our original list
sort $1 > $1_list1
dos2unix $1_list1

#REM then compare this two lists,find addtional nodes to delete
# subnetwork_nodelist has more nodes than 
comm -3 subnetwork_nodelist $1_list1 > nodestodelete
#REM delete lines containing unwanted nodes.
grep -vwF -f "nodestodelete" $2 > $1_cleaned-network
#REM delete temporary files.
rm nodelist1  nodestodelete $1_list1 subnetwork_nodelist
