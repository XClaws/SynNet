#  I use  this script to extract interested clusters. 
#  You could type in cluster IDs, and this will give you a clean network
#  Extract nodes from infoclusters result --> search network --> clean/simplify network --> R (network2matrix)
# $1 Network  clustering result (2cols) -infoclusters
# $2 Gene Name
# $3 network File
# Use another two scripts.

#clusterarray=(4269 3820) # EOG090A028E CHD1L
#clusterarray=(4215 3656) # EOG090A0698 AGT
#clusterarray=(4220 4006) # EOG090A06IV RGMB
#clusterarray=(4305 1579) # CATSPER4  EOG090A072I

#clusterarray=(4237 3810) #USP18
#clusterarray=(4173 4015) #MRPL19
#clusterarray=(4317 3460) #MAP9
#clusterarray=(4330 3673) #MINDY3
#clusterarray=(4097 3888) #CT90
#clusterarray=(4221 3286) #CLOM, COLM, CRG-L2, CRGL2, LCCS11, UNC-112
#clusterarray=(4111 3987) # CENPJ
#clusterarray=(4271 2454) # DFNB16
#clusterarray=(4193 3397) # BRCA2
#clusterarray=(4125 3411) # TRRAP
#clusterarray=(4194 3262) #IL23R
#clusterarray=(4215 3656) # AGT

# Plants
#clusterarray=(275) # CCD7
#clusterarray=(25) # sorting nexin 
#clusterarray=(322) # tocopherol cyclase, chloroplast / vitamin E deficient 1 (VTE1) / sucrose export defective 1 (SXD1)
#clusterarray=(19) # UbiA prenyltransferase family protein
#clusterarray=(2223 1021 2160) # DnaJ
#clusterarray=(481 2046) # ALDH12A

#clusterarray=(396 1973) # ACD1 
#clusterarray=(623 2109) #pTAC12
#clusterarray=(1749 1095 2240)  #SIGC 
#clusterarray=(480 3113 3505 3861)  #Pheophytin  ***
#clusterarray=(718 1841) #NOA1 ****
#clusterarray=(683 2381) #FAS2_ARATH  ***Cell
#clusterarray=(87 182) # Eric CCA1
clusterarray=(175 139 168) #RVE7


for i in "${clusterarray[@]}";do
awk "\$2==$i {print \$1}" $1 >> $2_genelist
done
python FindRecords.py ../SynNet-b5m25s5-2Cols $2_genelist $2_network
sh Clean_Network.sh $2_genelist $2_network
#rm candidate_gene_list
