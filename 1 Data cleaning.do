cd "C:\Users\rl423\OneDrive - University of Cambridge\PRU DCE_analysis"

clear
import excel "C:\Users\rl423\OneDrive - University of Cambridge\Documents\xMOVED TO TEAMS PRU\Screening harms DCE\f_Data and analysis\prudce_fulldataset_screening views_05Dec2024 full.xlsx", firstrow case(lower)

drop if exclude==1

drop exclude progress imaginethatyouwereinvitedto morepeoplewillbediagnosedw screeningoption1willprevent whensomebodyhasonetestins pleasetellusinafewwordswh

rename durationinseconds duration

rename doyouthinkroutinecancerscre enth1_screeninggood
rename howoftendoesfindingcancerea enth2_earlysaveslives
rename g enth3_earlysavestreatment
rename haveyoueverheardofcancerst enth4_slowknowledge
rename wouldyouwanttobetestedtos enth5_slowtest
rename iftherewasakindofcancerfo enth6_testuntreatable
rename inthepastdoyouthinkyouha enth7_screeningamount
rename doyoufeelthatsomeonewhodoe enth8_declineirresponsible

//check this is the right CS
rename q cs4
rename r cs5
rename s cs7
rename t cs8
rename u cs13
rename v cs14
rename w cs15
rename x cs16
rename y cs18
rename z cs1
rename aa cs2
rename ab cs3
rename ac cs6
rename ad cs9
rename ae cs10
rename af cs11
rename ag cs12
rename ah cs17 

rename ingeneralhoweasyordifficul eval_ease
rename didyoufindyourselfmakingcho eval_strategy
rename whichoutcomesdidyouusetohe eval_outcomesconsidered
rename pleaseranktheoutcomesinorde eval_rank_deathsprev
rename an eval_rank_cancersprev
rename ao eval_rank_overdd
rename ap eval_rank_falsepos
rename aq eval_rank_falseneg

rename howoldareyouinyears dem_age
rename whatisyoursexaquestionab dem_sex
rename isthegenderyouidentifywith dem_consistentgender
	drop au
rename whichoptionbestdescribesyour dem_ethnicity
	replace dem_ethnicity="White" if bg=="welsh" | bg=="European"
	replace dem_ethnicity="" if dem_ethnicity=="Prefer not to say"
		drop aw ax ay az ba bb bc bd be bg bf
rename whatisyourhighesteducationl dem_education
rename bi dem_education_text
	replace dem_education="Completed further education but not a degree" if dem_education_text=="Vocal qualifications - such as Certificate in Housing; management qualifications; project management qualifications..." | dem_education_text=="RSA in Business Studies"
	replace dem_education="Completed A Levels or equivalent" if dem_education_text=="Undergoing undergraduate degree"
	replace dem_education="Completed a Bachelor's/undergraduate degree" if dem_education_text=="2x Professional Exams." | dem_education_text=="Advanced Nurse Practitioner " | dem_education_text=="Dip he" | dem_education_text=="HNC" | dem_education_text=="HNC, Chartered Engineer" | dem_education_text=="Mental health nurse training" | dem_education_text=="NVQ4" | dem_education_text=="Post graduate diploma " | dem_education_text=="Professional qualification" | dem_education_text=="Professional qualification " | dem_education_text=="Registered Nurse"
	replace dem_education="Completed a Masters' degree or PhD" if dem_education_text=="FRCOG" | dem_education_text=="Fellowship of a Royal Medical College" | dem_education_text=="MbChB  FRCP" | dem_education_text==" Medical doctor" | dem_education_text=="Medical qualifications" | dem_education_text=="plus PGCE" | dem_education_text=="Medical doctor"
	replace dem_education="Prefer not to say" if dem_education_text=="Ranking Qu is bad. Made no sense. As compulsory, obliged me to give a reply not reflecting my thoughts. "
	drop dem_education_text
rename wherewouldyouputyourselfon dem_ses

rename haveyoueverhadcancer cancer_personalhistory
rename haveyourparentsoranybrother cancer_familyhistory
rename hasanyoneclosetoyouega cancer_closehistory
rename haveyouevertakenpartinaca cancer_screeningattendance
rename howlikelydoyouthinkisitth cancer_likelihood
rename duringthepastmonthhowoften cancer_worry
label variable cancer_screeningattendance "Have you ever taken part in a cancer screening programme?"
label variable dem_ses "Where would you put yourself on the socio-economic ladder?


**random study id
set seed 56
sort duration dem_age
generate randomid = floor((99999)*runiform() + 1), before(version)
	//check no duplicate numbers
	bysort randomid: gen count = _n, before(version)
	tab count
	gen simpleid = _n, before(randomid)
	replace randomid=randomid+simpleid if count>1
	bysort randomid: gen count2 = _n, before(version)
	tab count2
	drop count*


**describe arms
gen arm = 0
recode arm 0=1 if cs4 != ""
recode arm 0=2 if cs1 != ""


***tidy demographics
replace dem_age = . if dem_age>100
gen bdem_ageover50 = 0
	recode bdem_ageover50 0=1 if dem_age>=50
	replace bdem_ageover50 =. if dem_age==.

encode dem_sex, generate(d_sex)
	recode d_sex 3=.
	gen bdem_sex_female = 0
	recode bdem_sex_female 0=1 if d_sex==1
	recode bdem_sex_female 0=. if d_sex==.
	drop dem_sex
	rename d_sex dem_sex

encode dem_consistentgender, generate(dem_gendersame)
	recode dem_gendersame 3=1 1=0 2=.
	label define dem_gendersame 0 "No" 1 "Yes", replace
	drop dem_consistentgender 

encode dem_ethnicity, generate(d_ethnicity)
	gen bdem_eth_white = 0
	recode bdem_eth_white 0=1 if d_ethnicity == 5
	recode bdem_eth_white 0=. if d_ethnicity == . 
	drop dem_ethnicity
	rename d_ethnicity dem_ethnicity
	
encode dem_education, generate(dem_educat)
	recode dem_educat 6=1 2=2 1=3 5=4 3=5 4=6 7=.
	label define dem_educat 1 "Finished school before 15" 2 "GCSEs" 3 "A levels" 4 "Further education" 5 "UG degree" 6 "PG degree", replace
	drop dem_education 
	gen bdem_educat_degree = 0
	recode bdem_educat_degree 0=1 if dem_educat==5 | dem_educat==6
	recode bdem_educat_degree 0=. if dem_educat==.

destring dem_ses, replace force 
	gen bdem_ses_low = 0
	recode bdem_ses_low 0=1 if dem_ses<=3
	replace bdem_ses_low =. if dem_ses==.
	
encode cancer_personalhistory, generate(bcancer_personalhistory)
	recode bcancer_personalhistory (1=0) (3=1) (2=.)
	label drop bcancer_personalhistory
	//drop cancer_personalhistory

encode cancer_closehistory, generate(bcancer_closehistory)
	recode bcancer_closehistory (1=0) (3=1) (2=.)
	label drop bcancer_closehistory
	//drop cancer_closehistory

encode cancer_familyhistory, generate(bcancer_familyhistory)
	recode bcancer_familyhistory (1=0) (3=1) (2=.)
	label drop bcancer_familyhistory
	//drop cancer_familyhistory
	
encode cancer_screeningattendance, generate(cancer_screened)	
	recode cancer_screened (4 = 1) (2 = 2) (1 = 3) (3=.)
	label define cancer_screened 1 "Yes" 2 "No not invited" 3 "No chose not to", replace	
	drop cancer_screeningattendance
	gen bcancer_screened = 0
	recode bcancer_screened 0=1 if cancer_screened==1
	replace bcancer_screened =. if cancer_screened==.

rename cancer_likelihood cancer_likelihoodOLD
	encode cancer_likelihoodOLD, generate(cancer_likelihood)	
	recode cancer_likelihood (1=1) (3=2) (7=3) (5=4) (8=5) (4=6) (2=7) (6=.)
	label define cancer_likelihood 1 "Extremely likely" 2 "Moderately likely" 3 "Slightly likely" 4 "Neither likely nor unlikely" 5 "Slightly unlikely" 6 "Moderately unlikely" 7 "Extremely unlikely", replace	
	drop cancer_likelihoodOLD
	gen bcancer_likely = 0
	recode bcancer_likely 0=1 if cancer_likelihood<=3
	replace bcancer_likely =. if cancer_likelihood==.	
	
rename cancer_worry cancer_worryOLD
	encode cancer_worryOLD, generate(cancer_worry)	
	recode cancer_worry (2=1) (5=2) (6=3) (3=4) (1=5) (4=.)
	label define cancer_worry 1 "Not at all" 2 "Rarely" 3 "Sometimes" 4 "Often" 5 "A lot", replace	
	drop cancer_worryOLD
	gen bcancer_worried = 0
	recode bcancer_worried 0=1 if cancer_worry>=4
	replace bcancer_worried =. if cancer_worry==.
	
	
order dem_age bdem_ageover50				///
	dem_sex bdem_sex_female dem_gendersame	///
	dem_ethnicity bdem_eth_white			///
	dem_educat bdem_educat_degree			///
	dem_ses bdem_ses_low					///
	bcancer_personalhistory					///
	cancer_screened bcancer_screened		///
	cancer_likelihood bcancer_likely		///
	cancer_worry bcancer_worried, after(arm)

**version and sample
destring version, replace ignore(`"v"')
gen sample1 = "Thiscovery", after(version)
	replace sample1 = "Prolific" if version==3
	encode sample1, generate(sample)
	drop sample1
	order sample, after(version)

**tidy evaluation
rename eval_* eval_*OLD

gen eval_ease = 0
	label define ease 1 "very difficult" 2 "difficult" 3 "slightly difficult" 4 "slightly easy" 5 "easy" 6 "very easy"
	recode eval_ease 0 = . if eval_easeOLD == ""
	recode eval_ease 0 = 1 if eval_easeOLD == "5:Very difficult"
	recode eval_ease 0 = 2 if eval_easeOLD == "4:Difficult"
	recode eval_ease 0 = 3 if eval_easeOLD == "3:Slightly difficult"
	recode eval_ease 0 = 4 if eval_easeOLD == "2:Slightly easy"
	recode eval_ease 0 = 5 if eval_easeOLD == "1:Easy"
	recode eval_ease 0 = 6 if eval_easeOLD == "0:Very easy"
	label values eval_ease ease
	
	gen beval_easy = 0
	recode beval_easy 0=1 if eval_ease>=4
	replace beval_easy =. if eval_ease==.

encode eval_strategyOLD, generate(eval_strategy)	
	
split eval_outcomesconsideredOLD, generate(eval_attconsideredTEMP) parse(,)
	gen eval_attconsidered_cancerprev = 0
	gen eval_attconsidered_deathprev = 0
	gen eval_attconsidered_overdiag = 0
	gen eval_attconsidered_falsepos = 0
	gen eval_attconsidered_falseneg = 0
	
foreach v of varlist eval_attconsideredTEMP* {
	recode eval_attconsidered_cancerprev 0=1 if `v' == "All of the above"
	recode eval_attconsidered_cancerprev 0=1 if `v' == "Number of cancers that will be prevented"
	
	recode eval_attconsidered_deathprev 0=1 if `v' == "All of the above"
	recode eval_attconsidered_deathprev 0=1 if `v' == "Number of deaths from cancer that will be prevented"
	
	recode eval_attconsidered_overdiag 0=1 if `v' == "All of the above"
	recode eval_attconsidered_overdiag 0=1 if `v' == "Number of people diagnosed with a cancer that would not have caused them harm"
	
	recode eval_attconsidered_falseneg 0=1 if `v' == "All of the above"
	recode eval_attconsidered_falseneg 0=1 if `v' == "Number of people with a negative screening test when they actually do have cancer"
	
	recode eval_attconsidered_falsepos 0=1 if `v' == "All of the above"
	recode eval_attconsidered_falsepos 0=1 if `v' == "Number of people with a positive screening test but further investigations show that they do not have cancer"
  }	

 **ranking of attributes 
//keep eval_rank_deathsprevOLD eval_rank_cancersprevOLD eval_rank_overddOLD eval_rank_falseposOLD eval_rank_falsenegOLD
label variable eval_rank_deathsprevOLD "rank of deaths prevented"
label variable eval_rank_cancersprevOLD "rank of cancers prevented"
label variable eval_rank_overddOLD "rank of overdetection and overdiagnosis"
label variable eval_rank_falseposOLD "rank of false positives"
label variable eval_rank_falsenegOLD "rank of false negatives"

rename eval_rank_*OLD eval_rank_*

drop eval_*OLD *TEMP*
	

**tidy cancer and screening enthusiasm
label define yes_no 0 "no" 1 "yes"
label define amounttime 1 "all the time" 2 "most of the time" 3 "some of the time" 4 "none of the time"
label define amountscreening 0 "never had" 1 "too many" 2 "about right" 3 "too few"


encode enth1_screeninggood, generate(enthus1_screeninggood)
	recode enthus1 (2=1) (1=0)
	label values enthus1 yes_no
	
encode enth2_earlysaveslives, generate(enthus2_earlysaveslives)
	recode enthus2 (1=1) (2=2) (3=3) (4=4)
	label values enthus2 amounttime

encode enth3_earlysavestreatment, generate(enthus3_earlysavestreatment)
	recode enthus3 (1=1) (2=2) (4=3) (3=4)
	label values enthus3 amounttime
	
encode enth4_slowknowledge, generate(enthus4_slowknowledge)
	recode enthus4 (2=1) (1=0)
	label values enthus4 yes_no

encode enth5_slowtest, generate(enthus5_slowtest)
	recode enthus5 (2=1) (1=0)
	label values enthus5 yes_no

encode enth6_testuntreatable, generate(enthus6_testuntreatable)
	recode enthus6 (2=1) (1=0)
	label values enthus6 yes_no
	
encode enth7_screeningamount, generate(enthus7_screeningamount)
	recode enthus7 (2=0) (4=1) (1=2) (3=3)
	label values enthus7 amountscreening	

encode enth8_declineirresponsible, generate(enthus8_declineirresponsible)
	recode enthus8 (2=1) (1=0)
	label values enthus8 yes_no

drop enth1_screeninggood enth2_earlysaveslives enth3_earlysavestreatment enth4_slowknowledge enth5_slowtest enth6_testuntreatable enth7_screeningamount enth8_declineirresponsible

	//drop if dem_age<50 | dem_age>80
	tab enthus1, m
	tab enthus2, m	
	tab enthus3, m
	tab enthus4, m
	tab enthus5, m
	tab enthus6, m
	tab enthus7, m
	tab enthus8, m
	
gen enthus2_earlysaveslivesbin = ., after(enthus2_earlysaveslives)
	replace enthus2_earlysaveslivesbin =1 if enthus2_earlysaveslives <= 2
	replace enthus2_earlysaveslivesbin =0 if enthus2_earlysaveslives == 3 | enthus2_earlysaveslives == 4
	label variable enthus2_earlysaveslivesbin "How often does finding cancer early mean that treatment saves lives?"
	label define amounttime_bin 0 "none some of the time" 1 "all most of the time"
	label values enthus2_earlysaveslivesbin amounttime_bin
	drop enthus2_earlysaveslives

gen enthus3_earlysavestreatmentbin = ., after(enthus3_earlysavestreatment)
	replace enthus3_earlysavestreatmentbin =1 if enthus3_earlysavestreatment <= 2
	replace enthus3_earlysavestreatmentbin =0 if enthus3_earlysavestreatment == 3 | enthus3_earlysavestreatment == 4
	label variable enthus3_earlysavestreatmentbin "How often does finding cancer early mean that a person can have less treatment?"
	label values enthus3_earlysavestreatmentbin amounttime_bin
	drop enthus3_earlysavestreatment	

gen enthus7_toolittlescreeningbin = ., after(enthus7_screeningamount)
	replace enthus7_toolittlescreeningbin =1 if enthus7_screeningamount == 3
	replace enthus7_toolittlescreeningbin =0 if enthus7_screeningamount == 1 | enthus7_screeningamount == 2
	label variable enthus7_toolittlescreeningbin "In the past, do you think you have had too many screening tests for cancer, too "
	label values enthus7_toolittlescreeningbin yes_no
	drop enthus7_screeningamount	
	
	
**tidy DCE
label define option 1 "Opt 1" 2 "Opt 2" 0 "No screening"

foreach v of varlist cs* {
	encode `v', generate(choiceset`v')
	recode choiceset`v' (1=0) (2=1) (3=2)
	label values choiceset`v' option
	drop `v'
  } 

rename choicesetcs* choiceset*
order choiceset*, after(arm) alphabetic
  

gen count_option1 = 0, before(dem_age)
gen count_option2 = 0, before(dem_age)
gen count_noscreening = 0, before(dem_age)
foreach v of varlist choiceset* {
	replace count_option1 = count_option1+1 if `v' == 1
	replace count_option2 = count_option2+1 if `v' == 2
	replace count_noscreening = count_noscreening+1 if `v' == 0
  } 

  
save "PRU DCE full dataset.dta", replace
	
	
reshape long choiceset, i(randomid) j(question)

rename choiceset selectedoption
rename question choice_set
drop if selectedoption == .

joinby choice_set using "PRU DCE question matrix.dta", unmatched(none)
sort randomid choice_set alt
order randomid choice_set alt selectedoption arm

gen selection = 0, after(alt)
recode selection 0 = 1 if alt==1 & selectedoption == 1
recode selection 0 = 1 if alt==2 & selectedoption == 2
recode selection 0 = 1 if alt==3 & selectedoption == 0
drop selectedoption

egen case = group(randomid choice_set)
order case, after(randomid)


gen asc = 0, after(alt)
recode asc 0 = 1 if alt == 3

gen opt1 = 0, before(asc)
recode opt1 0 = 1 if alt == 1

gen opt2 = 0, before(asc)
recode opt2 0 = 1 if alt == 2



**create continuous variables for DCE attribute levels
gen cancersdiagnosed_ct = 0
	recode cancersdiagnosed_ct 0 = 50 if cancersprevented==1
	recode cancersdiagnosed_ct 0 = 49 if cancersprevented==2
	recode cancersdiagnosed_ct 0 = 48 if cancersprevented==3
	recode cancersdiagnosed_ct 0 = 44 if cancersprevented==4

gen cancerdeaths_ct = 0
	recode cancerdeaths_ct 0 = 10 if deathsprevented==1
	recode cancerdeaths_ct 0 = 7  if deathsprevented==2
	recode cancerdeaths_ct 0 = 5  if deathsprevented==3
	recode cancerdeaths_ct 0 = 3  if deathsprevented==4	
	
gen overdiagnosis_ct = 0
	recode overdiagnosis_ct 0 = 0  if overdiagnosis==1
	recode overdiagnosis_ct 0 = 2  if overdiagnosis==2
	recode overdiagnosis_ct 0 = 10 if overdiagnosis==3
	recode overdiagnosis_ct 0 = 15 if overdiagnosis==4
	recode overdiagnosis_ct 0 = 30 if overdiagnosis==5
	
gen falsepositives_ct = 0
	recode falsepositives_ct 0 = 0    if falsepositives==1
	recode falsepositives_ct 0 = 200  if falsepositives==2
	recode falsepositives_ct 0 = 300  if falsepositives==3
	recode falsepositives_ct 0 = 400  if falsepositives==4
	recode falsepositives_ct 0 = 500  if falsepositives==5
	
gen falsenegatives_ct = 0
	recode falsenegatives_ct 0 = 0   if falsenegatives==1
	recode falsenegatives_ct 0 = 1   if falsenegatives==2
	recode falsenegatives_ct 0 = 10  if falsenegatives==3
	recode falsenegatives_ct 0 = 20  if falsenegatives==4
	recode falsenegatives_ct 0 = 50  if falsenegatives==5	

	

**create effects coded variables

gen cancer_50=1 if cancersprevented == 1
	recode cancer_50 .=0
gen cancer_49=1 if cancersprevented == 2
	recode cancer_49 .=0
	recode cancer_49 0=-1 if cancersprevented ==1
gen cancer_48=1 if cancersprevented == 3
	recode cancer_48 .=0
	recode cancer_48 0=-1 if cancersprevented ==1
gen cancer_44=1 if cancersprevented == 4
	recode cancer_44 .=0
	recode cancer_44 0=-1 if cancersprevented ==1

gen deaths_10=1 if deathsprevented == 1
	recode deaths_10 .=0
gen deaths_7=1 if deathsprevented == 2
	recode deaths_7 .=0
	recode deaths_7 0=-1 if deathsprevented ==1
gen deaths_5=1 if deathsprevented == 3
	recode deaths_5 .=0
	recode deaths_5 0=-1 if deathsprevented ==1
gen deaths_3=1 if deathsprevented == 4
	recode deaths_3 .=0
	recode deaths_3 0=-1 if deathsprevented ==1	
	
rename overdiagnosis overdiagnosisTEMP	
gen overdiagnosis_0=1 if overdiagnosisTEMP == 1
	recode overdiagnosis_0 .=0
gen overdiagnosis_2=1 if overdiagnosisTEMP == 2
	recode overdiagnosis_2 .=0
	recode overdiagnosis_2 0=-1 if overdiagnosisTEMP ==1
gen overdiagnosis_10=1 if overdiagnosisTEMP == 3
	recode overdiagnosis_10 .=0
	recode overdiagnosis_10 0=-1 if overdiagnosisTEMP ==1
gen overdiagnosis_15=1 if overdiagnosisTEMP == 4
	recode overdiagnosis_15 .=0
	recode overdiagnosis_15 0=-1 if overdiagnosisTEMP ==1	
gen overdiagnosis_30=1 if overdiagnosisTEMP == 5
	recode overdiagnosis_30 .=0
	recode overdiagnosis_30 0=-1 if overdiagnosisTEMP ==1
	
rename falsepositives falseposTEMP	
gen falsepos_0=1 if falseposTEMP == 1
	recode falsepos_0 .=0
gen falsepos_200=1 if falseposTEMP == 2
	recode falsepos_200 .=0
	recode falsepos_200 0=-1 if falseposTEMP ==1
gen falsepos_300=1 if falseposTEMP == 3
	recode falsepos_300 .=0
	recode falsepos_300 0=-1 if falseposTEMP ==1
gen falsepos_400=1 if falseposTEMP == 4
	recode falsepos_400 .=0
	recode falsepos_400 0=-1 if falseposTEMP ==1	
gen falsepos_500=1 if falseposTEMP == 5
	recode falsepos_500 .=0
	recode falsepos_500 0=-1 if falseposTEMP ==1		

rename falsenegatives falsenegTEMP	
gen falseneg_0=1 if falsenegTEMP == 1
	recode falseneg_0 .=0
gen falseneg_1=1 if falsenegTEMP == 2
	recode falseneg_1 .=0
	recode falseneg_1 0=-1 if falsenegTEMP ==1
gen falseneg_10=1 if falsenegTEMP == 3
	recode falseneg_10 .=0
	recode falseneg_10 0=-1 if falsenegTEMP ==1
gen falseneg_20=1 if falsenegTEMP == 4
	recode falseneg_20 .=0
	recode falseneg_20 0=-1 if falsenegTEMP ==1	
gen falseneg_50=1 if falsenegTEMP == 5
	recode falseneg_50 .=0
	recode falseneg_50 0=-1 if falsenegTEMP ==1
	
drop cancersprevented deathsprevented overdiagnosisTEMP falseposTEMP falsenegTEMP
	
	
save "PRU DCE full dataset for DCE analysis.dta", replace
