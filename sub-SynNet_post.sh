# !/bin/bash
# Created 2021-03-24 @ WUR by Wei: automated post-process for subnetwork of certain target genefamily in SynNet 
display_usage() {

                echo -e "\nThis Script is for clustering and profiling of target gene family in Synteny Network Database"
        echo "To run the clustering and profiling, R script infomap.r and Phylogenomic_Profiling.r are needed"
		echo -e "\nUsage:bash sub-SynNet_post.sh <SynNet db> <target genelist> \n"
        echo -e "SynNet db: the origninal SynNet database created by Tao's pipeline \n"
        echo -e "target genelist: the prepared genelist for identified target family \n"
		
        }

# if less than one arguments supplied, display usage
        if [  $# -le 0 ]
        then
                display_usage
                exit 1
        fi

# check whether user had supplied -h or --help . If yes display usage
        if [[ ( $* == "--help") ||  $* == "-h" ]]
        then
                display_usage
                exit 0
        fi

# generate the simplified network data from the merged MCScanX output 
awk '{print $3" "$4}' $1 > $1.sim

# extract the sub-network from the synteny network database based on the target gene id list
grep -wf $2 $1 > $2.SynNet

# Prune genes not from the target group in the sub-network because of gene fusion/misannotation
awk '{print $3" "$4}' $2.SynNet|sort|uniq > $2.SynNet.sim # generate the simplified sub-network data
cat $2.SynNet.sim|awk '{print $1"\n"$2}'|sort|uniq > $2.SynNet.genelist # duplicate-removed gene list for pruning
grep -wvf $2 $2.SynNet.genelist > $2.prune.list # compare target genelist and subnetwork genelist to create prune list
grep -wvf $2.prune.list $2.SynNet.sim > $2.SynNet.sim.pruned # extract the sub-network excluding the non-target gene

# perform clustering to the entire network or subnetwork, columns should be separated by space not tab.
Rscript infomap.r $2.SynNet.sim.pruned $2.SynNet.sim.pruned.infoclu

# cut the Syntney Network based on the infomap clustering result to create a new subnetwork for SynNet visualization
# Use vlookup of Excel to label the gene pairs with their cluster number, keep the two genes if they are from the same community, otherwise remove the connection (nodes+edge) from the subnetwork.
# $2.SynNet.sim.pruned.clustered： reconstructed SynNet based on clustering

# perform the phylogenomic profiling and plot
Rscript Phylogenomic_Profiling.r $2.SynNet.sim.pruned.infoclu $2.SynNet.sim.pruned.infoclu.profiled $2.SynNet.sim.pruned.infoclu.profiled.clustered

exit 0
