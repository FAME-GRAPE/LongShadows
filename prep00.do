
// import excel "data/sources/OldWojPop", firstrow clear
// save data/OldWojPop, replace
// capture drop _merge
// import excel "data/sources/OldWojProd", firstrow clear
// save data/OldWojProd, replace
// this data reports growth by OldWoj, but not by region, used only for sanity checks

import excel "data/sources/OurBookData.xls", firstrow clear
drop Lp K L Stanobecny

ren Produkcjasprzedanaw1988rwmlnz sales
label var sales "sales in 1988 in mln PLZ"
ren Zatrudnieniew1988rwosobach labor
label var labor "employment in 1988"
ren Środkitrwałebruttow1988rwmlnz capital
label var capital "fixed assets in 1988 in mln PLZ"

foreach var in sales capital labor  {
replace `var' = ustrtrim(`var')
destring `var', replace ignore(" "; "–")
}

ren Rokuruchomienia yob
label var yob "year of birth"
destring yob, force replace
ren sekd nacerev1
label var nacerev1 "NACE Rev 1.1"
ren Nazwazakładu entity
ren Miejscowość city 
ren Województwo region
gen reg16 = .
label var reg16 "regions post 1999 reform"
do prep00_02_NewWoj_cleaning
gen NewWoj=region

replace city = strtrim(city)
gen OldWoj=""
gen reg49 = .
label var reg49 "regions pre1999 reform"
do prep00_03_OldWoj_cleaning
drop if city=="x"
drop if OldWoj=="" | OldWoj=="-"

/*
merge m:m OldWoj using data/OldWojPop
capture drop _merge
merge m:m OldWoj using data/OldWojProd
capture drop _merge
gen Pop89 = Pop90
gen Pop88 = Pop90
*/

gen cohort = floor(yob/10)*10

gen nacerev2=""
do prep00_01_nacerev2
label var nacerev2 "NACE Rev 2"
label var wiod "WIOD sectors"

save data/OurBookData, replace



