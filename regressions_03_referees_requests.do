 // The referee requested that we look at foreign owned and SOEs, this is the subsamples data
// subsamples1 "private domestic" subsamples2 "soe" subsamples3 "foreign" 

estimates clear

quietly {
preserve
local g growth_1996_1998
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_OldWoj
local opgap  "opgap_sect opgap_reg"
gen w_prod_reg = w_prod_OldWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) `g'_subsamples* `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(OldWoj nacerev1)
foreach sample in subsamples1 subsamples2 subsamples3 {
	local g growth_1996_1998
	local g `g'_`sample'
	eststo: reg 		`g' `opgap' $controls $overunder if `g' < $f 
}
restore

preserve
local g growth_1999_2005
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_sect opgap_reg"
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g'_subs* `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(NewWoj nacerev1)
foreach sample in subsamples1 subsamples2 subsamples3 {
	local g growth_1999_2005
	local g `g'_`sample'
	eststo: reg 		`g' `opgap' $controls $overunder if `g' < $f 
}
restore

preserve
local g growth_2005_2013
gen opgap_sect = opgap_nacerev2
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_sect opgap_reg"
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev2
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g'_subs* `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(NewWoj nacerev2)
foreach sample in subsamples1 subsamples2 subsamples3 {
	local g growth_2005_2013
	local g `g'_`sample'
	eststo: reg 		`g' `opgap' $controls $overunder if `g' < $f 
}
}
restore

local printto "using results/table_letter.csv"
esttab `printto', replace ///
		se(a2) r2 nolabel nogap not star(* .15 ** .10 *** .05) b(a2)   parentheses compress   ///
		drop(_cons) ///
		mtitles("1996-1998" "1996-1998"  "1996-1998" "1999-2005" "1999-2005"  "1999-2005" "2005-2013" "2005-2013" "2005-2013" ) ///
		coeflabels(opgap_reg "OP gap - region" opgap_sect "OP gap - sector" ///
			overcapitalized_DEU "share over-capitalized " undercapitalized_DEU "share under-capitalized") ///
		indicate("Output % (sector & region) = sales_share"   ///
		"Productivity (sector) = w_prod_sect"  "Productivity (region)= w_prod_reg"  )  
							  

							  
// The referee requested that we look at distance to Western Europe or some such
// Regional dummies instead (more flexible) 


estimates clear
quietly {
preserve
local g growth_1993_1998
gen opgap_sect = opgap_nacerev1
local opgap  "opgap_sect "
gen w_prod_sect = w_prod_nacerev2
local w_prod "w_prod_sect"
collapse (mean) 	`g' `opgap' $overunder `w_prod' $misaligned (sum) sales_share, by(OldWoj nacerev1)
eststo: xi:reg 		`g' `opgap' i.OldWoj sales_share if `g' < $f  $w
eststo: xi:reg 		`g' `opgap' $overunder i.OldWoj sales_share if `g' < $f   $w
eststo: xi:reg 		`g' `opgap' $misaligned i.OldWoj  sales_share if `g' < $f   $w
restore

preserve
local g growth_1999_2005
gen opgap_sect = opgap_nacerev1
local opgap  "opgap_sect "
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_sect"
collapse (mean) 		`g' `opgap' $overunder `w_prod' $misaligned (sum) sales_share, by(NewWoj nacerev1)
eststo: xi: reg 		`g' `opgap' i.NewWoj sales_share if `g' < $f  $w
eststo: xi: reg 		`g' `opgap' $overunder i.NewWoj sales_share if `g' < $f  $w
eststo: xi: reg 		`g' `opgap' $misaligned i.NewWoj  sales_share if `g' < $f  $w
restore

preserve
local g growth_2005_2013
gen opgap_sect = opgap_nacerev2
local opgap  "opgap_sect "
gen w_prod_sect = w_prod_nacerev2
local w_prod "w_prod_sect"
collapse (mean)			`g' `opgap' $overunder `w_prod' $misaligned (sum) sales_share, by(NewWoj nacerev2)
eststo: xi: reg 		`g' `opgap' i.NewWoj sales_share if `g' < $f  $w
eststo: xi: reg 		`g' `opgap' $overunder i.NewWoj sales_share if `g' < $f  $w
eststo: xi: reg 		`g' `opgap' $misaligned i.NewWoj sales_share if `g' < $f  $w
restore
}

local printto "using results/table_letter2.csv"
esttab `printto', replace ///
		se(a2) r2 nolabel nogap not star(* .15 ** .10 *** .05) b(a2) csv  parentheses compress   ///
		drop(_cons) ///
		mtitles("1993-1998" "1993-1998" "1993-1998" "1999-2005" "1999-2005" "1999-2005" "2005-2013" "2005-2013" "2005-2013" ) ///
		coeflabels( opgap_sect "OP gap - sector" ///
			overcapitalized_DEU "share over-capitalized" undercapitalized_DEU "share under-capitalized" ///
			firm_kl_misallocation_DEU "misallocation std" firm_kl_misallocation_DEU_2 "misallocation squared"  ) ///
		indicate("Output % (sector & region) = sales_share*"    )  
