*****This do-file takes raw WIOD data and turns it into benchmark statistics for selected countries and sectors for all available years

***Import and organize WIOD Excel File***
***WIOD Excel File was downloaded from https://www.rug.nl/ggdc/valuechain/wiod/wiod-2013-release***
*** File: https://dataverse.nl/api/access/datafile/199111

global vars "EMP EMPE K_GFCF"

import excel "data\sources\WIOD_SEA.xlsx", sheet("DATA") firstrow clear
foreach var in  GO $vars {
	preserve
	destring _*, replace force
	keep if Variable=="`var'"
	drop Variable
	drop Description
	ren Code wiodsector

	keep wiodsector Country _*
	reshape long _, i(Country wiodsector) j(year)
	ren _ `var'
	sort Country wiodsector
	save "data\WIOD_`var'", replace
	restore
}

use "data\WIOD_GO", clear
foreach filename in $vars {
	merge 1:1 Country wiod year using "data\WIOD_`filename'.dta", nogenerate
}

ren Country countrycode

***Selecting countries (Benchmarks) and statistics*** 
keep countrycode wiodsector year EMP EMPE K_GFCF
keep if inlist(countrycode,"POL","DEU","GBR","FRA","ITA")
drop if inlist(wiodsector,"AtB","50","51","52") | inlist(wiodsector,"60","61","62","63") | inlist(wiodsector,"64","70","71t74","H","F") | inlist(wiodsector,"J","L","M","N","O","P","TOT")
keep if !mi(K_GFCF) // no EMPE missing, some K_GFCF missing
gen KL =  log(K_GFCF) - log(EMPE)
***creating benchmark statistics***
foreach stat in mean median {
bys year countrycode: egen `stat'KL = `stat'(KL)
gen DIF`stat'KL = KL/`stat'KL
}

egen CY = concat(countrycode year)
drop countrycode year

ren KL KLratio

***reshaping in order to create year-specific statistics***
reshape wide EMP EMPE K_GFCF KL DIFmedianKL DIFmeanKL medianKL meanKL, i(wiodsector) j(CY) string

save data/WIODBenchmarkStats, replace

****Here we add the KL Ratio Stats for 1988 for Poland from the "book data" for comparison****
use data/OurBookData, clear

gen number =1
collapse (sum) number (sum) capital (sum) labor (sum) sales, by (wiodsector)

gen KLPOL1988=log(capital) - log(labor)
drop number capital labor sales

//creating KLPOL1988Mean, KLPOL1988Median & KLPOL1988DIF
egen medianKLPOL1988= median(KLPOL1988)
gen DIFmedianKLPOL1988= KLPOL1988/medianKLPOL1988
egen meanKLPOL1988= mean(KLPOL1988)
gen DIFmeanKLPOL1988= KLPOL1988/meanKLPOL1988

merge 1:1 wiodsector using "data/WIODBenchmarkstats"
drop _merge

save data/SectorDeviations, replace

