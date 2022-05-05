


preserve
foreach var in overcapitalized undercapitalized firm_kl_misallocation firm_kl_misallocation_pos {
graph bar (mean) `var'_*, over(wiod) ///
		legend(order(1 "POL" 2  "DEU" 3 "ITA" 4 "GBR" 5 "FRA" ) rows(1)) 
	graph save results/`var'_bars, replace
	graph export results/`var'_bars.png, replace
}

foreach cou in POL DEU ITA GBR FRA {
	rename DIFmeanKL`cou'1995 DIFmeanKL_`cou'
}


foreach var in DIFmeanKL {
graph bar (mean) `var'_*, over(wiod) ///
		legend(order(1  "DEU"  2 "FRA" 3 "GBR" 4 "ITA" 5 "POL") rows(1)) yline(1)
	graph save results/`var'_bars, replace
	graph export results/`var'_bars.png, replace
}

restore
