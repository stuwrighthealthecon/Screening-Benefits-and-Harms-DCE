cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

sysdir set PLUS "C:\Program Files(x86)\Stata15\"
ssc install clogithet

log using "Screening views comparison log.smcl", replace	

*************Prolific sample n=604********************
use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==2

**Creat piecewise variables
mkspline xcancersdiagnosed_48_1 48 xcancersdiagnosed_48_2 = cancersdiagnosed_ct


***enthusiasm 1
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus1 == 1, group(case)
estimates store enthus1YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus1 == 0, group(case)
estimates store enthus1NO

suest enthus1YES enthus1NO
test [enthus1YES_selection = enthus1NO_selection]


***enthusiasm 2
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus2 == 1, group(case)
estimates store enthus2MOST

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus2 == 0, group(case)
estimates store enthus2SOME

suest enthus2MOST enthus2SOME
test [enthus2MOST_selection = enthus2SOME_selection]


***enthusiasm 3
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus3 == 1, group(case)
estimates store enthus3MOST

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus3 == 0, group(case)
estimates store enthus3SOME

suest enthus3MOST enthus3SOME
test [enthus3MOST_selection = enthus3SOME_selection]


***enthusiasm 4
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus4 == 1, group(case)
estimates store enthus4YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus4 == 0, group(case)
estimates store enthus4NO

suest enthus4YES enthus4NO
test [enthus4YES_selection = enthus4NO_selection]


***enthusiasm 5
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus5 == 1, group(case)
estimates store enthus5YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus5 == 0, group(case)
estimates store enthus5NO

suest enthus5YES enthus5NO
test [enthus5YES_selection = enthus5NO_selection]


***enthusiasm 6
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus6 == 1, group(case)
estimates store enthus6YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus6 == 0, group(case)
estimates store enthus6NO

suest enthus6YES enthus6NO
test [enthus6YES_selection = enthus6NO_selection]


***enthusiasm 7
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus7 == 1, group(case)
estimates store enthus7YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus7 == 0, group(case)
estimates store enthus7NO

suest enthus7YES enthus7NO
test [enthus7YES_selection = enthus7NO_selection]


***enthusiasm 8
clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus8 == 1, group(case)
estimates store enthus8YES

clogit selection xcancersdiagnosed_48_1 xcancersdiagnosed_48_2 cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus8 == 0, group(case)
estimates store enthus8NO

suest enthus8YES enthus8NO
test [enthus8YES_selection = enthus8NO_selection]



*************Thiscovery sample n=604********************

use "PRU DCE full dataset for DCE analysis.dta", clear
drop if sample==1


***enthusiasm 1
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus1 == 1, group(case) het(version)
estimates store enthus1YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus1 == 0, group(case) het(version)
estimates store enthus1NO

//suest enthus1YES enthus1NO
//test [enthus1YES_selection = enthus1NO_selection]


//clogit selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus1 == 1, group(case) vce(robust)



***enthusiasm 2
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus2 == 1, group(case) het(version)
estimates store enthus2MOST

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus2 == 0, group(case) het(version)
estimates store enthus2SOME

//suest enthus2MOST enthus2SOME
//test [enthus2MOST_selection = enthus2SOME_selection]


***enthusiasm 3
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus3 == 1, group(case) het(version)
estimates store enthus3MOST

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus3 == 0, group(case) het(version)
estimates store enthus3SOME

//suest enthus3MOST enthus3SOME
//test [enthus3MOST_selection = enthus3SOME_selection]


***enthusiasm 4
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus4 == 1, group(case) het(version)
estimates store enthus4YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus4 == 0, group(case) het(version)
estimates store enthus4NO

//suest enthus4YES enthus4NO
//test [enthus4YES_selection = enthus4NO_selection]


***enthusiasm 5
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus5 == 1, group(case) het(version)
estimates store enthus5YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus5 == 0, group(case) het(version)
estimates store enthus5NO

//suest enthus5YES enthus5NO
//test [enthus5YES_selection = enthus5NO_selection]


***enthusiasm 6
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus6 == 1, group(case) het(version)
estimates store enthus6YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus6 == 0, group(case) het(version)
estimates store enthus6NO

//suest enthus6YES enthus6NO
//test [enthus6YES_selection = enthus6NO_selection]


***enthusiasm 7
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus7 == 1, group(case) het(version)
estimates store enthus7YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus7 == 0, group(case) het(version)
estimates store enthus7NO

//suest enthus7YES enthus7NO
//test [enthus7YES_selection = enthus7NO_selection]


***enthusiasm 8
clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus8 == 1, group(case) het(version)
estimates store enthus8YES

clogithet selection cancersdiagnosed_ct cancerdeaths_ct overdiagnosis_ct falsepositives_ct falsenegatives_ct asc if enthus8 == 0, group(case) het(version)
estimates store enthus8NO

//suest enthus8YES enthus8NO
//test [enthus8YES_selection = enthus8NO_selection]

log close
