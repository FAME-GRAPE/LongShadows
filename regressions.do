

* doing maps 
do regressions_01_maps

 * use the data, prepared in the earlier dofiles
do prep00 // this one cleans the original data from Karpinski et al
do prep01 // this one cleans the data from alternative sources which are later matched to the original data from Karpinski et al
drop if OldWoj=="" | cohort==1990 | mi(cohort)

* doing descriptives
do prep02_01_descriptives

egen cluster_rev1_reg49   = group(nacerev1 reg49)
egen cluster_rev1_reg16   = group(nacerev1 reg16)
egen cluster_rev2_reg16   = group(nacerev2 reg16)

global f "1" // not a binding constraint
global w ", robust"

global overunder 		"overcapitalized_DEU  undercapitalized_DEU  " 
global misaligned 		"firm_kl_misallocation_DEU firm_kl_misallocation2_DEU"
global misaligned_raw	"firm_kl_misall_raw_DEU firm_kl_misall2_raw_DEU"
global deviations		"c.DIFmeanKLDEU1995##c.DIFmeanKLDEU1995"
global controls 		"w_prod_reg w_prod_sect sales_share" 

* doing main results
do regressions_02_main_results

* doing checks for the referees
do regressions_03_referees_requests

* doing graphs for the main text
do regressions_04_graphs
