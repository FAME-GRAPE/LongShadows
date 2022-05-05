//do prep01_01_WIOD_benchmarks
//do prep01_02_fdata_productivity
//do prep01_03_GUS_productivity

use data/OurBookData, clear

/*
* Pop is population
* ProdYEAR has the following interpretation: 1% growth yields 101
forvalues y=89(1)97 {
	local y2 = `y'-1 
	gen dPop`y' = Pop`y'/Pop`y2' - 1
	gen dProdPC`y' = (Prod`y'/100) - dPop`y'
}
* dProdPC is measured in percent terms


gen growth_1990_1993 = 1	 
forvalues y=90(1)93 {
	replace growth_1990_1993 = growth_1990_1993 * (dProdPC`y')
}
replace growth_1990_1993=(growth_1990_1993-1)/4 // this adjustment for average annual from a four-year growth rate

drop dPop* dProd*
*/


******************************
** Merge in growth data ***
*******************************
sort nacerev1 OldWoj
merge m:1 nacerev1 OldWoj using data/f_data_19931998
drop if _merge==2
drop _merge

merge m:1 nacerev1 reg49 using data/f_data_19961998
drop if _merge==2
drop _merge

merge m:1 nacerev1 reg16 using data/f_data_19992005
drop if _merge==2
drop _merge

merge m:1 nacerev2 reg16 using data/f_data_20052013
drop if _merge==2
drop _merge

* label define type 1 "private domestic" 2 "soe" 3 "foreign" 
merge m:1 nacerev1 reg49 using data/f_data_19961998_subsamples
drop if _merge==2
drop _merge

merge m:1 nacerev1 reg16 using data/f_data_19992005_subsamples
drop if _merge==2
drop _merge

merge m:1 nacerev2 reg16 using data/f_data_20052013_subsamples
drop if _merge==2
drop _merge


******************************
** Merge in WIOD  data ***
*******************************

merge m:1 wiodsector using data/SectorDeviations
drop _merge

*************************************
*** Obtain OP gaps and other ****
*** misallocation measures     ****
*************************************
foreach var in sales labor {
		egen `var'_overall = total(`var')
	}

global dim "OldWoj NewWoj nacerev1 nacerev2 cohort wiod"
foreach dim in $dim {
	foreach var in sales labor {
		bysort `dim': egen `var'_`dim' = total(`var')
	}
gen si_`dim' = labor / labor_`dim'	
* weighted regional and sectoral productivites
bys `dim': egen w_prod_`dim' = total(si_`dim' * sales / labor) 
* simple regional and sectoral productivites
bys `dim': egen prod_`dim' = mean(sales / labor)
gen opgap_`dim' = (w_prod_`dim' -  prod_`dim') / w_prod_`dim'
bys `dim' : egen out_share_`dim' = sum(sales)
replace out_share_`dim' = out_share_`dim'  / sales_overall
}

gen sales_share = sales /sales_overall

gen si_overall = labor / labor_overall	
egen w_prod_overall = total(si_overall * sales / labor) 	
egen prod_overall = mean(sales / labor)
gen opgap_overall = (w_prod_overall -  prod_overall) / w_prod_overall 
		
gen 			klratio = capital / labor
egen 			klratio_mean = mean(klratio)
egen 			klratio_sd = sd(klratio)
bys wiod : egen klratio_mean_sector = mean(klratio)
bys wiod : egen klratio_sd_sector = sd(klratio)


foreach cou in POL DEU ITA GBR FRA {
gen target_klratio_`cou' = DIFmeanKL`cou'1995  * klratio_mean
label var target_klratio_`cou' "target KL ratio country-level"
gen overcapitalized_`cou'= klratio > 1.1* target_klratio_`cou' if klratio!=.
label var overcapitalized_`cou' "firm overcapitalized relative to country-level"
gen undercapitalized_`cou'= klratio < 0.9* target_klratio_`cou' if klratio!=.
label var undercapitalized_`cou' "firm undercapitalized relative to country-level"

gen firm_kl_misallocation_`cou' = (klratio - target_klratio_`cou')/klratio_sd_sector
gen firm_kl_misallocation2_`cou' = firm_kl_misallocation_`cou'^2

gen firm_kl_misallocation_pos_`cou' = firm_kl_misallocation_`cou' if firm_kl_misallocation_`cou'>=0
replace firm_kl_misallocation_pos_`cou' =0 if firm_kl_misallocation_`cou'<0

gen firm_kl_misallocation_neg_`cou' = -firm_kl_misallocation_`cou' if firm_kl_misallocation_`cou'<0
replace firm_kl_misallocation_neg_`cou' =0 if firm_kl_misallocation_`cou'>0

gen firm_kl_misall_raw_`cou' = (klratio - target_klratio_`cou')
gen firm_kl_misall2_raw_`cou' = firm_kl_misall_raw_`cou'^2


}

egen labor_total = total(labor)
gen si_total = labor/labor_total
egen si_mean = mean(si_total)
egen labor_prod_mean = mean(sales/labor)
gen opgap_cov = (sales/labor - labor_prod_mean) * (si_total - si_mean)



gen opgap_pos = opgap_cov>0


