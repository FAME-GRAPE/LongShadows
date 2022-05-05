forvalues year=1993(1)1998 {
	import excel "data\sources\GUS_ordered.xlsx", sheet("dane_`year'") firstrow case(lower) clear
	drop if sekd=="ie"
	destring sekd, replace
	drop ogółem
	destring przychody-narzuty, replace ignore(#)
	gen year=`year'
	save "data\gus_`year'", replace
}

clear
forvalues year=1993(1)1998 {
	append using "data\gus_`year'"
}

// Here we fix regions (old NUTS, woj)
gen reg49 = .
gen OldWoj = wo

do prep00_03_OldWoj_cleaning2


// Here we harmonize sectors (sekd)
drop if sekd < 15 | sekd > 41 // dropping agriculture and services 
ren sekd nacerev1
gen nacerev2=""
do prep00_01_nacerev2
drop if wiod==""
ren przychody sales
format sales %12.0g

// Do the aggregates at sector level for the whole country
drop if wo=="wo" // overall aggregates
replace sales = sales / 10 if year<1995 // remember denomination
bys year: egen sales_total = sum(sales)
egen group=group(nacerev1 OldWoj)
tsset group year

gen ppi = ((sales_total - L5.sales_total ) / L5.sales_total)/5
gen growth_1993_1998= ((sales - L5.sales ) / L5.sales)/5  // this adjustment for average annual from a five-year growth rate
replace growth_1993_1998 = growth_1993_1998 - ppi 
keep if year==1998
keep OldWoj reg49 wiod wiodsector nacerev1 growth
save "data\f_data_19931998", replace

forvalues y=3(1)8 {
erase "data\gus_199`y'.dta"
}
