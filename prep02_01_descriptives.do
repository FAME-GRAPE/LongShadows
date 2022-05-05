
noisily capture erase results/misal.txt
foreach var in opgap_pos  overcapitalized_POL overcapitalized_DEU overcapitalized_ITA overcapitalized_GBR overcapitalized_FRA undercapitalized_POL undercapitalized_DEU undercapitalized_ITA undercapitalized_GBR undercapitalized_FRA {
	reg `var' i.cohort i.nacerev1 i.reg16 , robust nocons 
	outreg2 using results/misal, excel append ctitle(`var') label
}

noisily capture erase results/misal_continuous.txt
foreach var in opgap_cov  firm_kl_misallocation_POL firm_kl_misallocation_DEU firm_kl_misallocation_ITA firm_kl_misallocation_GBR firm_kl_misallocation_FRA  {
	reg `var' i.cohort i.nacerev1 i.reg16 , robust nocons 
	outreg2 using results/misal_continuous, excel append ctitle(`var') label
}


 capture postclose our_anova
    postfile our_anova str30(variable model) result using results/our_anova, replace

    set matsize 10000
    foreach var in opgap_cov opgap_pos  firm_kl_misallocation_POL firm_kl_misallocation_DEU firm_kl_misallocation_ITA firm_kl_misallocation_GBR firm_kl_misallocation_FRA  {
        anova `var' i.cohort i.nacerev1 i.reg16 
        post our_anova  ("`var'") ("all") (`e(r2)')
        anova `var' i.cohort  
        post our_anova ("`var'") ("cohort") (`e(r2)')
        anova `var' i.nacerev1 
        post our_anova ("`var'") ("sector") (`e(r2)')
        anova `var' i.reg16 
		post our_anova ("`var'") ("region") (`e(r2)')
           }

    postclose our_anova

	
tabout reg16 wiod using results/descriptives1.xls, replace
tabout wiod cohort using results/descriptives2.xls, replace
tabout reg16 cohort using results/descriptives3.xls, replace


gen ones = 1


tabout wiod using results/descriptives4.xls, replace ///
		 c(sum ones mean opgap_wiod mean overcapitalized_DEU mean undercapitalized_DEU mean firm_kl_misallocation_DEU mean firm_kl_misallocation_pos_DEU mean firm_kl_misallocation_neg_DEU ) ///
		 sum f(0c 3 3 3 3 3 3 3) 
		 
tabout cohort using results/descriptives5.xls, replace ///
		 c(sum ones mean opgap_wiod mean overcapitalized_DEU mean undercapitalized_DEU mean firm_kl_misallocation_DEU mean firm_kl_misallocation_pos_DEU mean firm_kl_misallocation_neg_DEU )  ///
		 sum f(0c 3 3 3 3 3 3 3) 

tabout NewWoj using results/descriptives6.xls, replace ///
		 c(sum ones mean opgap_wiod mean overcapitalized_DEU mean undercapitalized_DEU mean firm_kl_misallocation_DEU mean firm_kl_misallocation_pos_DEU mean firm_kl_misallocation_neg_DEU )  ///
		 sum f(0c 3 3 3 3 3 3 3) 