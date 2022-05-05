
replace nacerev2 = "5" 			if nacerev1==10
replace nacerev2 = "6"			if nacerev1==11
replace nacerev2 = "7"			if nacerev1==13
replace nacerev2 = "8"			if nacerev1==14
replace nacerev2 = "10_11"  if nacerev1==15
replace nacerev2 = "12"		if nacerev1==16
replace nacerev2 = "13"		if nacerev1==17
replace nacerev2 = "14"		if nacerev1==18
replace nacerev2 = "15"		if nacerev1==19
replace nacerev2 = "16"		if nacerev1==20
replace nacerev2 = "17"		if nacerev1==21
replace nacerev2 = "18"		if nacerev1==22
replace nacerev2 = "19"		if nacerev1==23
replace nacerev2 = "20_21"  if nacerev1==24
replace nacerev2 = "22"		if nacerev1==25
replace nacerev2 = "23"		if nacerev1==26
replace nacerev2 = "24"		if nacerev1==27
replace nacerev2 = "25"		if nacerev1==28
replace nacerev2 = "26"		if nacerev1==30
replace nacerev2 = "26"		if nacerev1==32
replace nacerev2 = "26"		if nacerev1==33
replace nacerev2 = "27"		if nacerev1==31
replace nacerev2 = "28"		if nacerev1==29
replace nacerev2 = "29"		if nacerev1==34
replace nacerev2 = "30"		if nacerev1==35
replace nacerev2 = "31_32" if nacerev1==36
replace nacerev2 = "33"		if nacerev1==37

****name WIOD sectors according to sector codes, dropping non-industrial sectors***
gen wiod = ""
replace wiod = "C" 		if  	inrange(nacerev1,10,14) // C
replace wiod = "DA" 	if  	inrange(nacerev1,15,16) // 15t16
replace wiod = "DB" 	if  	inrange(nacerev1,17,18) // 17t18
replace wiod = "DC" 	if  	inlist(nacerev1,19) // 19
replace wiod = "DD" 	if  	inlist(nacerev1,20) 		// 20
replace wiod = "DE" 	if  	inrange(nacerev1,21,22)  // 21t22
replace wiod = "DF" 	if  	inlist(nacerev1,23) 		// 23
replace wiod = "DG" 	if  	inlist(nacerev1,24) 		// 24
replace wiod = "DH" 	if  	inlist(nacerev1,25) 		// 25
replace wiod = "DI" 		if  	inlist(nacerev1,26) 		// 26
replace wiod = "DJ" 	if  	inrange(nacerev1,27,28)  // 27t28
replace wiod = "DK" 	if  	inlist(nacerev1,29) 		// 29
replace wiod = "DL" 	if  	inrange(nacerev1,30,33)  // 30t33
replace wiod = "DM" 	if  	inrange(nacerev1,34,35)  // 34t35
replace wiod = "DN" 	if  	inrange(nacerev1,36,38)  // 36t37
replace wiod = "E" 		if  	inlist(nacerev1,40,41)  // E
replace wiod = "F" 		if  	inlist(nacerev1,45)  // F

gen wiodsector = ""
replace wiodsector = "C" 		if  	inrange(nacerev1,10,14) // C
replace wiodsector = "15t16" 	if  	inrange(nacerev1,15,16) // 15t16
replace wiodsector = "17t18" 	if  	inrange(nacerev1,17,18) // 17t18
replace wiodsector = "19" 	if  	inlist(nacerev1,19) // 19
replace wiodsector = "20" 	if  	inlist(nacerev1,20) 		// 20
replace wiodsector = "21t22" 	if  	inrange(nacerev1,21,22)  // 21t22
replace wiodsector = "23" 	if  	inlist(nacerev1,23) 		// 23
replace wiodsector = "24" 	if  	inlist(nacerev1,24) 		// 24
replace wiodsector = "25" 	if  	inlist(nacerev1,25) 		// 25
replace wiodsector = "26" 		if  	inlist(nacerev1,26) 		// 26
replace wiodsector = "27t28" 	if  	inrange(nacerev1,27,28)  // 27t28
replace wiodsector = "29" 	if  	inlist(nacerev1,29) 		// 29
replace wiodsector = "30t33" 	if  	inrange(nacerev1,30,33)  // 30t33
replace wiodsector = "34t35" 	if  	inrange(nacerev1,34,35)  // 34t35
replace wiodsector = "36t37" 	if  	inrange(nacerev1,36,38)  // 36t37
replace wiodsector = "E" 		if  	inrange(nacerev1,40,41)  // E
replace wiodsector = "F" 		if  	inlist(nacerev1,45)  // F
