* Obtain estimates of productivity from F data
* nace rev 1 - OldWoj
* nace rev 1 - NewWoj
* nace rev 2 - NewWoj
use  "data/sources/F_f01", clear
tsset idn year

gen reg16= .
gen reg49 = .
replace reg49 = wojews if year < 1999
// fixing regions in 1996 (missing)
bys idn: egen aux = mean(wojews)
replace reg49 = aux if mi(wojews)
replace reg16 = wojew if year > 1998

bysort year: egen tot_sales = total(sales_revenues)
replace sales_revenues = sales_revenues / tot_sales

drop if mi(wo) | mi(sekd)
keep if sekd < 41
ren sekd nacerev1 

gen nacerev2=""
do prep00_01_nacerev2
label var nacerev2 "NACE Rev 2"
label var wiod "WIOD sectors"

***********************************************************************

preserve 
collapse (sum) sales_revenues , by(year reg49 nacerev1)
egen idn = group(reg49 nacerev1)
drop if mi(idn)
tsset idn year
sum sales_revenues 

gen growth_1996_1998 = (sales_revenues / l2.sales_revenues - 1) /2
keep if year==1998
sum growth* 
keep growth_1996_1998 reg49 nacerev1
sum growth_1996_1998
save data\f_data_19961998, replace
restore

preserve 
collapse (sum) sales_revenues , by(year reg16 nacerev1)
egen idn = group(reg16 nacerev1)
drop if mi(idn)
tsset idn year
gen growth_1999_2005 = (sales_revenues / l6.sales_revenues - 1) /6
keep if year==2005
keep growth_1999_2005 reg16 nacerev1
save data\f_data_19992005, replace
restore

preserve 
collapse (sum) sales_revenues , by(year reg16 nacerev2)
egen idn = group(reg16 nacerev2)
drop if mi(idn)
tsset idn year
gen growth_2005_2013 = (sales_revenues / l8.sales_revenues - 1) /8
keep if year==2013
keep growth_2005_2013 reg16 nacerev2
save data\f_data_20052013, replace
restore






** repeat the same generation with separate identification of foreign and state firms


egen type = group(partial state)
label define type 1 "private domestic" 2 "soe" 3 "foreign" 
label values type type

preserve 
collapse (sum) sales_revenues , by(year reg49 nacerev1 type)
egen idn = group(reg49 nacerev1 type)
drop if mi(idn)
tsset idn year
gen growth_1996_1998_subsamples = (sales_revenues / l2.sales_revenues - 1) /2
keep if year==1998
keep growth_1996_1998 reg49 nacerev1 type
reshape wide growth_1996_1998_subsamples, j(type) i(nacerev1 reg49)
save data\f_data_19961998_subsamples, replace
restore

preserve 
collapse (sum) sales_revenues , by(year reg16 nacerev1 type)
egen idn = group(reg16 nacerev1 type)
drop if mi(idn)
tsset idn year
gen growth_1999_2005_subsamples = (sales_revenues / l6.sales_revenues - 1) /6
keep if year==2005
keep growth_1999_2005 reg16 nacerev1 type
reshape wide growth_1999_2005_subsamples, j(type) i(nacerev1 reg16)
save data\f_data_19992005_subsamples, replace
restore

preserve 
collapse (sum) sales_revenues , by(year reg16 nacerev2 type)
egen idn = group(reg16 nacerev2 type)
drop if mi(idn)
tsset idn year
gen growth_2005_2013_subsamples = (sales_revenues / l8.sales_revenues - 1) /8
keep if year==2013
keep growth_2005_2013 reg16 nacerev2 type
reshape wide growth_2005_2013_subsamples, j(type) i(nacerev2 reg16)
save data\f_data_20052013_subsamples, replace
restore