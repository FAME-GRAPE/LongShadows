*********************************
* preparation for maps
*************************************


cd "data\sources\shp"
shp2dta using wojewodztwa, database(pldb) coordinates(plcoord) genid(id) gencentroids(centr) replace
cd ..\..\...

* use the data, prepared in the earlier dofiles
do prep00 // this one cleans the original data from Karpinski et al
do prep01 // this one cleans the data from alternative sources which are later matched to the original data from Karpinski et al

collapse (mean) overcapitalized_DEU undercapitalized_DEU (mean) opgap_NewWoj (first) reg16, by(NewWoj)
gen jpt_kod_je  = string(reg16,"%02.0f")

global opts "label(region) xcoord(x_) ycoord(y_) by(labtype) size(*0.85 ..) pos(12 0) "

merge 1:1 jpt_kod_je using "data\sources\pldb"
ren NewWoj region
replace opgap = 100*opgap
replace undercapitalized=100*undercapitalized
replace overcapitalized=100*overcapitalized

tempfile mapdata
save `mapdata', replace

use `mapdata', clear
gen labtype=1
append using `mapdata'
replace labtype=2 if labtype==.

replace region = string(opgap, "%4.1f") if labtype==2
keep id region x_ y_ `var' labtype
save "data\sources\shp\labels_opgap.dta", replace

use `mapdata', clear
sum opgap, det
local min = round(r(min),3) -10
local max = round(r(max),3) +10
local scale = round((`max' - `min')/5,1)

spmap opgap 			using  "data\sources\plcoord", id(id)  ///
				fcolor(PuOr) label(data("data\sources\shp\labels_opgap.dta") $opts ) clmethod(custom) clbreaks(`min' (`scale') `max') 
	graph save 		results/maps/opgap_map_r, replace
	graph export 	results/maps/opgap_map_r.png, replace
	graph export 	results/maps/opgap_map_r.pdf, replace
	
use `mapdata', clear
gen labtype=1
append using `mapdata'
replace labtype=2 if labtype==.

replace region = string(undercapitalized, "%4.1f") if labtype==2
keep id region x_ y_ `var' labtype
save "data\sources\shp\labels_undercapitalized.dta", replace

use `mapdata'
sum undercapitalized, det
local min = round(r(min),3) -10
local max = round(r(max),3) +10
local scale = round((`max' - `min')/5,1)

spmap undercapitalized 	using  "data\sources\shp\plcoord", id(id)  ///
				fcolor(Reds) label(data("data\sources\shp\labels_undercapitalized.dta") $opts ) clmethod(custom) clbreaks(`min' (`scale') `max') 
	graph save 		results/maps/undercapitalized_map_s, replace
	graph export 	results/maps/undercapitalized_map_s.png, replace
	graph export 	results/maps/undercapitalized_map_s.pdf, replace

	
use `mapdata', clear
gen labtype=1
append using `mapdata'
replace labtype=2 if labtype==.

replace region = string(overcapitalized, "%4.1f") if labtype==2
keep id region x_ y_ `var' labtype
save "data\sources\shp\labels_overcapitalized.dta", replace

use `mapdata'
sum overcapitalized, det
local min = round(r(min),3) -10
local max = round(r(max),3) +10
local scale = round((`max' - `min')/5,1)

spmap overcapitalized 	using  "data\sources\shp\plcoord", id(id)  ///
				fcolor(Reds) label(data("data\sources\shp\labels_overcapitalized.dta") $opts ) clmethod(custom) clbreaks(`min' (`scale') `max') 
	graph save 		results/maps/overcapitalized_map_s, replace
	graph export 	results/maps/overcapitalized_map_s.png, replace
	graph export 	results/maps/overcapitalized_map_s.pdf, replace

