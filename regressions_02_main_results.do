
*****************************
* Table 1
*****************************
estimates clear

quietly {
preserve
local g growth_1993_1998
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_OldWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_OldWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g' `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(OldWoj nacerev1)
eststo: reg 		`g' `opgap' $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $overunder $controls   if `g' < $f   $w
eststo: reg 		`g' `opgap' $misaligned $controls   if `g' < $f   $w
restore

preserve
local g growth_1999_2005
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g' `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(NewWoj nacerev1)
eststo: reg 		`g' `opgap' $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $overunder $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $misaligned $controls  if `g' < $f  $w
restore

preserve
local g growth_2005_2013
gen opgap_sect = opgap_nacerev2
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev2
local w_prod "w_prod_reg w_prod_sect"
collapse (mean)		`g' `opgap' $overunder $misaligned `w_prod' (sum) sales_share, by(NewWoj nacerev2)
eststo: reg 		`g' `opgap' $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $overunder $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $misaligned $controls  if `g' < $f  $w
restore
}

local printto "using results/table_1.csv"
esttab `printto', replace ///
		se(a2) r2 nolabel nogap not star(* .15 ** .10 *** .05) b(a2)  parentheses  compress  ///
		drop(_cons) ///
		mtitles("1993-1998" "1993-1998" "1993-1998" "1999-2005" "1999-2005" "1999-2005" "2005-2013" "2005-2013" "2005-2013" ) ///
		coeflabels(opgap_reg "OP gap - region" opgap_sect "OP gap - sector" ///
			overcapitalized_DEU "share overcapitalized" undercapitalized_DEU "share undercapitalized" ///
			firm_kl_misallocation_DEU "misallocation std" firm_kl_misallocation2_DEU " -- squared"  ) ///
		indicate("Output % (sector & region) = sales_share"   ///
		"Productivity (sector) = w_prod_sect"  "Productivity (region)= w_prod_reg"  )  
		  
// The above can run at firm level with standard errors clustered at a right level
// Ultimately the difference is whether one believes that the regression weights should reflect the 
// pre-1989 structure of the economy (firm level) or not (sector-industry level).



*****************************
* Table 2
*****************************
estimates clear

quietly {
preserve
local g growth_1993_1998
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_OldWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_OldWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g' `opgap'  $misaligned_raw  `w_prod' klratio (sum) sales_share, by(OldWoj nacerev1)
eststo: reg 		`g' `opgap' $misaligned_raw $controls  if `g' < $f   $w
eststo: reg 		`g' `opgap' $controls klratio if `g' < $f   $w
restore

preserve
local g growth_1999_2005
gen opgap_sect = opgap_nacerev1
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev1
local w_prod "w_prod_reg w_prod_sect"
collapse (mean) 	`g' `opgap'  $misaligned_raw `w_prod' klratio (sum) sales_share, by(NewWoj nacerev1)
eststo: reg 		`g' `opgap' $misaligned_raw $controls   if `g' < $f  $w
eststo: reg 		`g' `opgap' $controls klratio if `g' < $f  $w
restore

preserve
local g growth_2005_2013
gen opgap_sect = opgap_nacerev2
gen opgap_reg = opgap_NewWoj
local opgap  "opgap_reg opgap_sect "
gen w_prod_reg = w_prod_NewWoj
gen w_prod_sect = w_prod_nacerev2
local w_prod "w_prod_reg w_prod_sect"
collapse (mean)		`g' `opgap' $misaligned_raw  `w_prod' klratio (sum) sales_share, by(NewWoj nacerev2)
eststo: reg 		`g' `opgap' $misaligned_raw $controls  if `g' < $f  $w
eststo: reg 		`g' `opgap' $controls klratio if `g' < $f  $w
restore
}

local printto "using results/table_2.csv"
esttab `printto', replace ///
		se(a2) r2 nolabel nogap not star(* .15 ** .10 *** .05) b(a2)  parentheses  compress  ///
		drop(_cons) ///
		mtitles("1993-1998" "1993-1998" "1999-2005" "1999-2005" "2005-2013" "2005-2013" ) ///
		coeflabels(opgap_reg "OP gap - region" opgap_sect "OP gap - sector" ///
		firm_kl_misall_raw_DEU "misallocation raw" firm_kl_misall2_raw_DEU " -- squared" klratio "average K/L ratio" ) ///
		indicate("Output % (sector & region) = sales_share"   ///
		"Productivity (sector) = w_prod_sect"  "Productivity (region)= w_prod_reg"  )  
		
		
		
*****************************
* Table 3
*****************************
estimates clear
capture erase results/table_3.csv

foreach cou in POL DEU ITA GBR FRA {
		global overunder 	overcapitalized_`cou'  undercapitalized_`cou' 
		quietly {
		preserve
		local g growth_1993_1998
		gen opgap_sect = opgap_nacerev1
		gen opgap_reg = opgap_OldWoj
		local opgap  "opgap_reg opgap_sect "
		gen w_prod_reg = w_prod_OldWoj
		gen w_prod_sect = w_prod_nacerev1
		local w_prod "w_prod_reg w_prod_sect"
		collapse (mean) 	`g' `opgap' $overunder  `w_prod' (sum) sales_share, by(OldWoj nacerev1)
		eststo: reg 		`g' `opgap' $overunder $controls   if `g' < $f   $w
		restore

		preserve
		local g growth_1999_2005
		gen opgap_sect = opgap_nacerev1
		gen opgap_reg = opgap_NewWoj
		local opgap  "opgap_reg opgap_sect "
		gen w_prod_reg = w_prod_NewWoj
		gen w_prod_sect = w_prod_nacerev1
		local w_prod "w_prod_reg w_prod_sect"
		collapse (mean) 	`g' `opgap' $overunder  `w_prod' (sum) sales_share, by(NewWoj nacerev1)
		eststo: reg 		`g' `opgap' $overunder $controls  if `g' < $f  $w
		restore

		preserve
		local g growth_2005_2013
		gen opgap_sect = opgap_nacerev2
		gen opgap_reg = opgap_NewWoj
		local opgap  "opgap_reg opgap_sect "
		gen w_prod_reg = w_prod_NewWoj
		gen w_prod_sect = w_prod_nacerev2
		local w_prod "w_prod_reg w_prod_sect"
		collapse (mean)		`g' `opgap' $overunder  `w_prod' (sum) sales_share, by(NewWoj nacerev2)
		eststo: reg 		`g' `opgap' $overunder $controls  if `g' < $f  $w
		restore
		}


local printto "using results/table_3.csv"
esttab `printto', append ///
		se(a2) r2 nolabel nogap not star(* .15 ** .10 *** .05) b(a2)  parentheses  compress fragment ///
		keep(overcapitalized_`cou' undercapitalized_`cou') ///
		mtitles("1993-1998"  "1999-2005" "2005-2013"  ) ///
		coeflabels(overcapitalized_`cou' "share overcapitalized" undercapitalized_`cou' "share undercapitalized") 
}