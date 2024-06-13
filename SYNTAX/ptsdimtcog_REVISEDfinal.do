capture log close
capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\DATA_MANAGEMENT1.smcl"


**STEP 0: OPEN FILES AND CREATE HHIDPN VARIABLE, SORT BY THIS VARIABLE**

cd "E:\HANDLS_PAPER67_PTSD_COGN\DATA"

use 2024-01-30_ptsdimt,clear
capture rename HNDid HNDID
save, replace
describe
su

//STEP 1: CREATE DEMOGRAPHIC VARIABLES//
keep HNDID Race PovStat Sex Age
capture rename HNDid HNDID
sort HNDID
save DEMO, replace

save HANDLS_PTSDIMTCOG,replace
capture drop _merge
sort HNDID
save, replace
merge HNDID using DEMO

save, replace


//STEP 2: CREATE COGNITIVE DATA//
use 2024-01-30_ptsdimt,clear
keep HNDID Attention BVRadd BVRdes BVRdis BVRfig BVRmis BVRomm BVRper BVRqui BVRrot BVRsiz BVRtot ClockCmdFace ClockCmdHand ClockCmdNumb ClockCopFace ClockCopHand ClockCopNumb CrdRotCor CrdRotErr CrdRot CVLca1 CVLca2 CVLca3 CVLtcb CVLfrs CVLfrl CVLhit CVLbet DigitSpanFwd DigitSpanFwdMax DigitSpanBck DigitSpanBckMax FluencyIntr FluencyPers FluencyWord IdentPicCor IdentPicErr MMSatn MMSdel MMSimm MMSlan MMSnvalid MMSorp MMSort MMSspell MMStot MMStotpro TrailsAsampErr TrailsAsampSec TrailsAtestErr TrailsAtestSec TrailsBsampErr TrailsBsampSec TrailsBtestErr TrailsBtestSec CVLtca 
sort HNDID
save COGNITIVE_TEST_SCORES, replace

use 2024-01-30_ptsdimt,clear
sort HNDID
save, replace

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using COGNITIVE_TEST_SCORES
save, replace

//STEP 3: CREATE IMT DATA//
use 2024-01-30_ptsdimt,clear
keep HNDID IMThr1 IMTbp1sys IMTbp1dia IMTmean1 IMThr2 IMTbp2sys IMTbp2dia IMTmean2 IMTleft IMT1 IMT2 IMT3 IMT4 IMT5 IMTsysDIM1 IMTsysDIM2 IMTsysDIM3 IMTdiaDIM1 IMTdiaDIM2 IMTdiaDIM3 IMTccaSYS IMTccaDIA IMTccaEMEN IMTccaPI IMTside IMTmean
sort HNDID
save IMT_SCORES, replace

use 2024-01-30_ptsdimt,clear
sort HNDID
save, replace

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using IMT_SCORES
save, replace

//STEP 4: PTSD//
use 2024-01-30_ptsdimt,clear
keep HNDID acasiPTSD
sort HNDID
save PTSD_SCORES, replace

use 2024-01-30_ptsdimt,clear
sort HNDID
save, replace

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using PTSD_SCORES
save, replace


//STEP 5: CREATE ALL OTHER COVARIATE VARIABLES AND MERGE WITH FINAL FILE//

//EDUCATION//
use 2024-01-30_ptsdimt,clear
keep HNDID EducationYr
capture rename EducationYr Education
save Education, replace
sort HNDID
save,replace

use 2024-01-30_ptsdimt,clear
sort HNDID
save, replace

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Education
save, replace


tab Education

capture drop edubr
gen edubr=.
replace edubr=1 if Education>=1 & Education<=8
replace edubr=2 if Education>=9 & Education<=12
replace edubr=3 if Education>=13 & Education~=.

tab edubr
tab edubr Education

save, replace

//LIFESTYLE FACTORS: SMOKING AND DRUG USE: CigaretteStatus and MarijCurr, CokeCurr, OpiateCurr//

use 2024-01-30_ptsdimt,clear
save, replace


keep HNDID CigaretteStatus MarijCurr CokeCurr OpiateCurr
sort HNDID
save Smoke_drugs,replace

tab1 MarijCurr CokeCurr OpiateCurr

capture drop currdrugs
gen currdrugs=.
replace currdrugs=1 if MarijCurr==1 | CokeCurr==1 | OpiateCurr==1
replace currdrugs=0 if MarijCurr~=1 & CokeCurr~=1 & OpiateCurr~=1 & MarijCurr~=. & CokeCurr~=. & OpiateCurr~=.
replace currdrugs=9 if currdrugs==.

tab currdrugs
tab currdrugs MarijCurr
tab currdrugs CokeCurr
tab currdrugs OpiateCurr

save, replace


**Current smoking status**

tab CigaretteStatus
su CigaretteStatus

capture drop smokebr
gen smokebr=.
replace smokebr=1 if CigaretteStatus==4 
replace smokebr=0 if CigaretteStatus~=4 & CigaretteStatus~=.
replace smokebr=9 if smokebr==.

tab smokebr CigaretteStatus

capture drop smoke1 smoke9
gen smoke1=1 if smokebr==1
replace smoke1=0 if smokebr~=1

gen smoke9=1 if smokebr==9
replace smoke9=0 if smokebr~=9

sort HNDID

save, replace

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using Smoke_drugs 
save, replace

//WRAT, CES-D, BMI, SELF-RATED HEALTH AND CO-MORBIND CONDITIONS//

use 2024-01-30_ptsdimt,clear
save, replace


keep HNDID WRATlett WRATword WRATtotal WRATgrade CES CES_DA CES_IP CES_SC CES_WB BMI SF01 dxHTN dxDiabetes CVhighChol CVaFib CVangina CVcad CVchf CVmi rxCholesterolemia allostatic_load acasiPTSD

save HEALTH, replace

tab SF01


capture drop SRH
gen SRH=.
replace SRH=1 if SF01==1 | SF01==2
replace SRH=2 if SF01==3
replace SRH=3 if SF01==4 | SF01==5


tab SRH

save, replace

su dxHTN dxDiabetes

tab1 dxHTN dxDiabetes


tab1 CVhighChol 

save, replace

tab1  CVaFib CVangina CVcad CVchf CVmi

capture drop cvdbr
gen cvdbr=.
replace cvdbr=1 if CVaFib==2 | CVangina==2 | CVcad==2 | CVchf==2 | CVmi==2
replace cvdbr=0 if cvdbr~=1 & CVaFib~=. & CVangina~=. & CVcad~=. & CVchf~=. & CVmi~=.


tab cvdbr


sort HNDID
save, replace


use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace


merge HNDID using HEALTH
save, replace


//OTHER DIETARY FACTORS//

use 2024-01-30_ptsdimt,clear
save, replace

keep HNDID hei2010_total_score Energy_d1 Energy_d2
sort HNDID
save Otherdietarys,replace

**Energy intake**

capture drop Energy_mean
gen Energy_mean=(Energy_d1+Energy_d2)/2

su Energy_mean
histogram Energy_mean


**HEI**

su hei2010_total_score
histogram hei2010_total_score


sort HNDID

save, replace



use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace



merge HNDID using Otherdietarys
save, replace

****WRAT total*****

use 2024-01-30_ptsdimt,clear
save, replace


keep HNDID WRATtotal 
sort HNDID
save WRAT,replace


su WRATtotal
histogram WRATtotal


use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

merge HNDID using WRAT
save HANDLS_PTSDIMTCOG, replace

//STEP 6: CREATE ALL COGNITIVE TEST SCORES AND THEIR SELECTION VARIABLES//

use HANDLS_PTSDIMTCOG,clear
sort HNDID
capture drop _merge
save, replace

**MMSE total score**

capture drop selectmms
gen selectmms=.
replace selectmms=1 if MMStot~=.
replace selectmms=0 if selectmms~=1
tab selectmms


su MMStot if selectmms==1


**CVLT, LIST A, Immediate Recall**
capture drop selectcvltca
gen selectcvltca=.
replace selectcvltca=1 if CVLca1~=. & CVLca2~=. & CVLca3~=.
replace selectcvltca=0 if selectcvltca~=1 & CVLca1~=1 & CVLca2~=1 & CVLca3~=1
tab selectcvltca

capture drop cvltca
gen cvltca=CVLca1+CVLca2+CVLca3

su cvltca if selectcvltca==1

**CVLT, Free long recall**

capture drop selectcvlfrl
gen selectcvlfrl=.
replace selectcvlfrl=1 if CVLfrl~=.
replace selectcvlfrl=0 if selectcvlfrl~=1 
tab selectcvlfrl

su CVLfrl if selectcvlfrl==1


save,replace


**BVRT**  

capture drop selectBVRtot
gen selectBVRtot=.
replace selectBVRtot=1 if BVRtot~=. 
replace selectBVRtot=0 if selectBVRtot~=1 
tab selectBVRtot

su BVRtot if selectBVRtot==1


**Attention**
capture drop selectAttention
gen selectAttention=.
replace selectAttention=1 if Attention~=. 
replace selectAttention=0 if selectAttention~=1 
tab selectAttention

su Attention if selectAttention==1


**Word Fluency**
capture drop selectFluencyWord
gen selectFluencyWord=.
replace selectFluencyWord=1 if FluencyWord~=. 
replace selectFluencyWord=0 if selectFluencyWord~=1 
tab selectFluencyWord

su FluencyWord if selectFluencyWord==1


save, replace


**Digits Span forward**
capture drop selectDigitSpanFwd
gen selectDigitSpanFwd=.
replace selectDigitSpanFwd=1 if DigitSpanFwd~=. 
replace selectDigitSpanFwd=0 if selectDigitSpanFwd~=1 
tab selectDigitSpanFwd

su DigitSpanFwd if selectDigitSpanFwd==1

save, replace


**Digits Span backward**
capture drop selectDigitSpanBck
gen selectDigitSpanBck=.
replace selectDigitSpanBck=1 if DigitSpanBck~=. 
replace selectDigitSpanBck=0 if selectDigitSpanBck~=1 
tab selectDigitSpanBck

su DigitSpanBck if selectDigitSpanBck==1

save, replace


**Clock command**
capture drop clock_command
gen clock_command=ClockCmdFace+ClockCmdHand+ClockCmdNumb

capture drop selectclock_command
gen selectclock_command=.
replace selectclock_command=1 if clock_command~=. 
replace selectclock_command=0 if selectclock_command~=1 
tab selectclock_command

su clock_command if selectclock_command==1


save, replace


**TRAILS A**
capture drop selectTrailsAtestSec
gen selectTrailsAtestSec=.
replace selectTrailsAtestSec=1 if TrailsAtestSec~=. 
replace selectTrailsAtestSec=0 if selectTrailsAtestSec~=1 
tab selectTrailsAtestSec

su TrailsAtestSec if selectTrailsAtestSec==1


**TRAILS B**

capture drop selectTrailsBtestSec 
gen selectTrailsBtestSec=. 
replace selectTrailsBtestSec=1 if TrailsBtestSec~=. 
replace selectTrailsBtestSec=0 if selectTrailsBtestSec~=1 
tab selectTrailsBtestSec 

su TrailsBtestSec  if selectTrailsBtestSec==1


save, replace


**WRATT**
capture drop selectWRATtotal
gen selectWRATtotal=.
replace selectWRATtotal=1 if WRATtotal~=. 
replace selectWRATtotal=0 if selectWRATtotal~=1 

tab selectWRATtotal

su WRATtotal if selectWRATtotal==1

capture drop _merge
sort HNDID
save, replace


**Card rotation**
capture drop selectcrdrot
gen selectcrdrot=1 if CrdRot~=.
replace selectcrdrot=0 if selectcrdrot~=1

tab selectcrdrot

su CrdRot if selectcrdrot==1

 
** Identical pictures**
capture drop identpictot
gen identpictot=IdentPicCor - (0.25*IdentPicErr)
capture drop selectidentpic
gen selectidentpic=1 if  identpictot~=. 
replace selectidentpic=0 if selectidentpic~=1

tab selectidentpic

su identpictot if selectidentpic==1

//STEP 7: CREATE selectcog//

capture drop selectcogn

gen selectcogn=.

replace selectcogn=1 if selectmms==1 | selectcvltca==1 | selectcvlfrl==1 | selectBVRtot==1 | selectAttention==1 | selectFluencyWord==1 | selectDigitSpanFwd==1 | selectDigitSpanBck==1 | selectclock_command==1 |selectTrailsAtestSec==1 | selectTrailsBtestSec==1| selectWRATtotal==1 | selectcrdrot==1 | selectidentpic==1

replace selectcogn=0 if selectcogn~=1

tab selectcogn


//STEP 8: CREATE ALL OTHER COVARIATE VARIABLES AND THEIR SELECTION VARIABLES//

**CES TOTAL SCORES**
capture drop selectces
gen selectces=.
replace selectces=1 if CES~=.
replace selectces=0 if selectces~=1 
tab selectces

su CES if selectces==1

**CES_DA**

capture drop selectcesda
gen selectcesda=.
replace selectcesda=1 if CES_DA~=.
replace selectcesda=0 if selectcesda~=1 
tab selectcesda

su CES_DA if selectcesda==1

**CES_IP**

capture drop selectcesip
gen selectcesip=.
replace selectcesip=1 if CES_IP~=.
replace selectcesip=0 if selectcesip~=1 
tab selectcesip

su CES_IP if selectcesip==1

**CES_SC**

capture drop selectcessc
gen selectcessc=.
replace selectcessc=1 if CES_SC~=.
replace selectcessc=0 if selectcessc~=1 
tab selectcessc

su CES_SC if selectcessc==1

**CES_WB**

capture drop selectceswb
gen selectceswb=.
replace selectceswb=1 if CES_WB~=.
replace selectceswb=0 if selectceswb~=1 
tab selectceswb

su CES_WB if selectceswb==1

**EDUCATION**
capture drop selecteducation
gen selecteducation=.
replace selecteducation=1 if Education~=.
replace selecteducation=0 if selecteducation~=1 
tab selecteducation

su  Education if selecteducation==1

**SELF-RATED HEALTH**
capture drop selectSRH
gen selectSRH=.
replace selectSRH=1 if SRH~=.
replace selectSRH=0 if selectSRH~=1 
tab selectSRH

su  SRH if selectSRH==1

**dxHTN**
capture drop selectdxHTN
gen selectdxHTN=.
replace selectdxHTN=1 if dxHTN~=.
replace selectdxHTN=0 if selectdxHTN~=1 
tab selectdxHTN

su  dxHTN if selectdxHTN==1


**DIABETES**
tab dxDiabetes
su dxDiabetes

capture drop selectdxDiabetes
gen selectdxDiabetes=.
replace selectdxDiabetes=1 if dxDiabetes==1 
replace selectdxDiabetes=0 if dxDiabetes~=1 

su dxDiabetes if selectdxDiabetes==1


**rxCholesterolemia**
capture drop selectrxCholesterolemia
gen selectrxCholesterolemia=.
replace selectrxCholesterolemia=1 if rxCholesterolemia~=.
replace selectrxCholesterolemia=0 if selectrxCholesterolemia~=1 
tab selectrxCholesterolemia

su rxCholesterolemia if selectrxCholesterolemia==1


**CVhighChol**
capture drop selectCVhighChol 
gen selectCVhighChol =.
replace selectCVhighChol=1 if CVhighChol~=.
replace selectCVhighChol=0 if selectCVhighChol~=1 
tab selectCVhighChol 

su CVhighChol if selectCVhighChol==1

**Energy_mean**
capture drop selectEnergy_mean
gen selectEnergy_mean=.
replace selectEnergy_mean=1 if Energy_mean~=.
replace selectEnergy_mean=0 if selectEnergy_mean~=1 
tab selectEnergy_mean

su Energy_mean if selectEnergy_mean==1


**hei2010_total_score**
capture drop selecthei2010_total_score
gen selecthei2010_total_score=.
replace selecthei2010_total_score=1 if hei2010_total_score~=.
replace selecthei2010_total_score=0 if selecthei2010_total_score~=1 
tab selecthei2010_total_score

su hei2010_total_score if selecthei2010_total_score==1


**WRATlett**
capture drop selectWRATlett
gen selectWRATlett=.
replace selectWRATlett=1 if WRATlett~=.
replace selectWRATlett=0 if selectWRATlett~=1 
tab selectWRATtotal

su WRATlett if selectWRATlett==1

**WRATword**
capture drop selectWRATword
gen selectWRATword=.
replace selectWRATword=1 if WRATword~=.
replace selectWRATword=0 if selectWRATword~=1 
tab selectWRATword

su WRATword if selectWRATword==1

**WRATgrade**
capture drop selectWRATgrade
gen selectWRATgrade=.
replace selectWRATgrade=1 if WRATgrade~=.
replace selectWRATgrade=0 if selectWRATgrade~=1 
tab selectWRATgrade

su WRATgrade if selectWRATgrade==1

**allostatic_load**
capture drop selectallostatic_load
gen selectallostatic_load=.
replace selectallostatic_load=1 if allostatic_load~=.
replace selectallostatic_load=0 if selectallostatic_load~=1
 
tab selectallostatic_load

su allostatic_load if selectallostatic_load==1


//STEP 10: CREATE IMT TOTAL SCORES VARIABLES AND THEIR SELECTION VARIABLES//

**IMThr1**
capture drop selectimthr1
gen selectimthr1=.
replace selectimthr1=1 if IMThr1~=.
replace selectimthr1=0 if selectimthr1~=1 
tab selectimthr1

su IMThr1 if selectimthr1==1

**IMTbp1sys**
capture drop sselectimtbp1sys
gen selectimtbp1sys=.
replace selectimtbp1sys=1 if IMTbp1sys~=.
replace selectimtbp1sys=0 if selectimtbp1sys~=1 
tab selectimtbp1sys

su IMTbp1sys if selectimtbp1sys==1

**IMTbp1dia**
capture drop selectimtbp1dia
gen selectimtbp1dia=.
replace selectimtbp1dia=1 if IMTbp1dia~=.
replace selectimtbp1dia=0 if selectimtbp1dia~=1 
tab selectimtbp1dia

su IMTbp1dia if selectimtbp1dia==1

**IMTmean1**
capture drop selectimtmean1
gen selectimtmean1=.
replace selectimtmean1=1 if IMTmean1~=.
replace selectimtmean1=0 if selectimtmean1~=1 
tab selectimtmean1

su IMTmean1 if selectimtmean1==1

**IMThr2**
capture drop selectimthr2
gen selectimthr2=.
replace selectimthr2=1 if IMThr2~=.
replace selectimthr2=0 if selectimthr2~=1 
tab selectimthr2

su IMThr2 if selectimthr2==1

**IMTbp2sys**
capture drop selectimtbp2sys
gen selectimtbp2sys=.
replace selectimtbp2sys=1 if IMTbp2sys~=.
replace selectimtbp2sys=0 if selectimtbp2sys~=1 
tab selectimtbp2sys

su IMTbp2sys if selectimtbp2sys==1

**IMTbp2dia**
capture drop selectimtbp2dia
gen selectimtbp2dia=.
replace selectimtbp2dia=1 if IMTbp2dia~=.
replace selectimtbp2dia=0 if selectimtbp2dia~=1 
tab selectimtbp2dia

su IMTbp2dia if selectimtbp2dia==1

**IMTmean2**
capture drop selectimtmean2
gen selectimtmean2=.
replace selectimtmean2=1 if IMTmean2~=.
replace selectimtmean2=0 if selectimtmean2~=1 
tab selectimtmean2

su IMTmean2 if selectimtmean2==1

**IMTleft**
capture drop selectimtleft
gen selectimtleft=.
replace selectimtleft=1 if IMTleft~=.
replace selectimtleft=0 if selectimtleft~=1 
tab selectimtleft

su IMTleft if selectimtleft==1


**IMT1**
capture drop selectimt1
gen selectimt1=.
replace selectimt1=1 if IMT1~=.
replace selectimt1=0 if selectimt1~=1 
tab selectimt1

su IMT1 if selectimt1==1

**IMT2**
capture drop selectimt2
gen selectimt2=.
replace selectimt2=1 if IMT2~=.
replace selectimt2=0 if selectimt2~=1 
tab selectimt2

su IMT2 if selectimt2==1

**IMT3**
capture drop selectimt3
gen selectimt3=.
replace selectimt3=1 if IMT3~=.
replace selectimt3=0 if selectimt3~=1 
tab selectimt3

su IMT3 if selectimt3==1

**IMT4**
capture drop selectimt4
gen selectimt4=.
replace selectimt4=1 if IMT4~=.
replace selectimt4=0 if selectimt4~=1 
tab selectimt4

su IMT4 if selectimt4==1

**IMT5**
capture drop selectimt5
gen selectimt5=.
replace selectimt5=1 if IMT5~=.
replace selectimt5=0 if selectimt5~=1 
tab selectimt5

su IMT5 if selectimt5==1

**IMTsysDIM1**
capture drop selectimtsysdim1
gen selectimtsysdim1=.
replace selectimtsysdim1=1 if IMTsysDIM1~=.
replace selectimtsysdim1=0 if selectimtsysdim1~=1 
tab selectimtsysdim1

su IMTsysDIM1 if selectimtsysdim1==1

**IMTsysDIM2**
capture drop selectimtsysdim2
gen selectimtsysdim2=.
replace selectimtsysdim2=1 if IMTsysDIM2~=.
replace selectimtsysdim2=0 if selectimtsysdim2~=1 
tab selectimtsysdim2

su IMTsysDIM2 if selectimtsysdim2==1

**IMTsysDIM3**
capture drop selectimtsysdim3
gen selectimtsysdim3=.
replace selectimtsysdim3=1 if IMTsysDIM3~=.
replace selectimtsysdim3=0 if selectimtsysdim3~=1 
tab selectimtsysdim3

su IMTsysDIM2 if selectimtsysdim2==1

**IMTdiaDIM1**
capture drop selectimtdiadim1
gen selectimtdiadim1=.
replace selectimtdiadim1=1 if IMTdiaDIM1~=.
replace selectimtdiadim1=0 if selectimtdiadim1~=1 
tab selectimtdiadim1

su IMTdiaDIM1 if selectimtdiadim1==1

**IMTdiaDIM2**
capture drop selectimtdiadim2
gen selectimtdiadim2=.
replace selectimtdiadim2=1 if IMTdiaDIM2~=.
replace selectimtdiadim2=0 if selectimtdiadim2~=1 
tab selectimtdiadim2

su IMTdiaDIM2 if selectimtdiadim2==1

**IMTdiaDIM3**
capture drop selectimtdiadim3
gen selectimtdiadim3=.
replace selectimtdiadim3=1 if IMTdiaDIM3~=.
replace selectimtdiadim3=0 if selectimtdiadim3~=1 
tab selectimtdiadim3

su IMTdiaDIM3 if selectimtdiadim3==1

**IMTccaSYS**
capture drop selectimtccasys
gen selectimtccasys=.
replace selectimtccasys=1 if IMTccaSYS~=.
replace selectimtccasys=0 if selectimtccasys~=1 
tab selectimtccasys

su IMTccaSYS if selectimtccasys==1

**IMTccaDIA**
capture drop selectimtccadia
gen selectimtccadia=.
replace selectimtccadia=1 if IMTccaDIA~=.
replace selectimtccadia=0 if selectimtccadia~=1 
tab selectimtccadia

su IMTccaDIA if selectimtccadia==1

**IMTccaEMEN**
capture drop selectimtccaemen
gen selectimtccaemen=.
replace selectimtccaemen=1 if IMTccaEMEN~=.
replace selectimtccaemen=0 if selectimtccaemen~=1 
tab selectimtccaemen

su IMTccaEMEN if selectimtccaemen==1

**IMTccaPI**
capture drop selectimtccapi
gen selectimtccapi=.
replace selectimtccapi=1 if IMTccaPI~=.
replace selectimtccapi=0 if selectimtccapi~=1 
tab selectimtccapi

su IMTccaPI if selectimtccapi==1

**IMTside**
capture drop selectimtside
gen selectimtside=.
replace selectimtside=1 if  IMTside~=.
replace selectimtside=0 if selectimtside~=1 
tab selectimtside

su  IMTside if selectimtside==1

**IMTmean**
capture drop selectimtmean
gen selectimtmean=.
replace selectimtmean=1 if  IMTmean~=.
replace selectimtmean=0 if selectimtmean~=1 
tab selectimtmean

su  IMTmean if selectimtmean==1


//STEP 12: CREATE PTSD VARIABLE, EXPOSURE**
capture drop selectPTSD
gen selectPTSD=.
replace selectPTSD=1 if acasiPTSD~=.
replace selectPTSD=0 if selectPTSD~=1
 
tab selectPTSD

su acasiPTSD if selectPTSD==1


//PART 13: CREATE FINAL SAMPLE// N = 1,434, Excluded =   2,286// 
capture drop sample_final
gen sample_final=.
replace sample_final=1 if selectcogn==1 & selectPTSD==1 & selectces==1 & IMTmean~=.
replace sample_final=0 if sample_final~=1
tab sample_final

save, replace

//FIGURE 1: PARTICIPANT FLOWCHART// *TOTAL N = 1,434


**SAMPLE 1: N =  3,032 ; Exclude =  688**
capture drop sample1
gen sample1=.
replace sample1=1 if selectcogn==1
replace sample1=0 if sample1~=1
tab sample1

save, replace


**SAMPLE 2** N = 2,240; Exclude = 1,480 minus 688
capture drop sample2
gen sample2=.
replace sample2=1 if sample1==1 & selectPTSD==1
replace sample2=0 if sample2~=1
tab sample2

save, replace

**SAMPLE 3** N =   2,203 ; Exclude = 1,517 minus 1,480
capture drop sample3
gen sample3=.
replace sample3=1 if  sample2==1 & selectces==1 
replace sample3=0 if sample3~=1
tab sample3

save, replace

***FINAL SAMPLE** N = 1,434; Exclude = 2,286 minus 1,517
capture drop sample4
gen sample4=.
replace sample4=1 if  sample3==1 & selectimtmean==1 
replace sample4=0 if sample4~=1
tab sample4

save, replace




//PART 14: CREATE INVERSE MILLS RATIOS FOR FINAL SELECTED SAMPLE FOR LINEAR REGRESSION MODELS//
use HANDLS_PTSDIMTCOG, clear

xi:probit sample_final Age Race PovStat Sex

capture drop p1final
predict p1final, xb

capture drop phifinal
capture drop caphifinal
capture drop invmillsfinal

gen phifinal=(1/sqrt(2*_pi))*exp(-(p1final^2/2))

egen caphifinal=std(p1final)

capture drop invmillsfinal
gen invmillsfinal=phifinal/caphifinal


su invmillsfinal

//PART 15: NORMALIZE MMSE & LOG-TRANSFORM TRIALS A & B//
capture drop MMStotnorm
gen MMStotnorm=.
replace MMStotnorm=0 if MMStot==0
replace MMStotnorm=2.91 if MMStot==1
replace MMStotnorm=5.48 if MMStot==2
replace MMStotnorm=7.76 if MMStot==3
replace MMStotnorm=9.77 if MMStot==4
replace MMStotnorm=11.57 if MMStot==5
replace MMStotnorm=13.19 if MMStot==6
replace MMStotnorm=14.67 if MMStot==7
replace MMStotnorm=16.05 if MMStot==8
replace MMStotnorm=17.37 if MMStot==9
replace MMStotnorm=18.68 if MMStot==10
replace MMStotnorm=20.01 if MMStot==11
replace MMStotnorm=21.38 if MMStot==12
replace MMStotnorm=22.83 if MMStot==13
replace MMStotnorm=24.39 if MMStot==14
replace MMStotnorm=26.07 if MMStot==15
replace MMStotnorm=27.91 if MMStot==16
replace MMStotnorm=29.93 if MMStot==17
replace MMStotnorm=32.17 if MMStot==18
replace MMStotnorm=34.64 if MMStot==19
replace MMStotnorm=37.37 if MMStot==20
replace MMStotnorm=40.40 if MMStot==21
replace MMStotnorm=43.70 if MMStot==22
replace MMStotnorm=47.40 if MMStot==23
replace MMStotnorm=51.44 if MMStot==24
replace MMStotnorm=55.98 if MMStot==25
replace MMStotnorm=61.18 if MMStot==26
replace MMStotnorm=67.25 if MMStot==27
replace MMStotnorm=74.61 if MMStot==28
replace MMStotnorm=84.32 if MMStot==29
replace MMStotnorm=100 if MMStot==30

save, replace

su MMStotnorm
histogram MMStotnorm if selectmms==1

**Trails A: LnTrailsAtestSec**
capture drop LnTrailsAtestSec
gen LnTrailsAtestSec=ln(TrailsAtestSec)

su LnTrailsAtestSec if selectTrailsAtestSec==1 


**Trails B: LnTrailsBtestSec**
capture drop LnTrailsBtestSec
gen LnTrailsBtestSec=ln(TrailsBtestSec)

su LnTrailsBtestSec if selectTrailsBtestSec==1 

save, replace


//STEP 23: MULTIPLE IMPUTATIONS FOR COVARIATES////////
use HANDLS_PTSDIMTCOG,clear

sort HNDID


save finaldata_imputed,replace


capture set matsize 11000

capture mi set flong

capture mi xtset, clear

capture mi stset, clear

save, replace

su Age Sex Race PovStat edubr  currdrugs smokebr BMI SRH hei2010_total_score dxHTN dxDiabetes CVhighChol cvdbr 


replace smokebr=. if smokebr==9
save, replace

replace currdrugs=. if currdrugs==9
save, replace

replace SRH=. if SRH==9
save, replace


mi unregister Age Sex Race PovStat edubr currdrugs smokebr BMI SRH hei2010_total_score Energy_mean WRATtotal dxHTN dxDiabetes CVhighChol cvdbr allostatic_load

mi register imputed edubr currdrugs smokebr BMI SRH hei2010_total_score Energy_mean WRATtotal dxHTN dxDiabetes CVhighChol cvdbr allostatic_load   


mi impute chained (ologit) edubr smokebr currdrugs dxHTN dxDiabetes CVhighChol cvdbr SRH WRATtotal (regress)  BMI Energy_mean allostatic_load hei2010_total_score=Age Sex Race PovStat if Age~=., force augment noisily  add(5) rseed(1234) savetrace(tracefile, replace)


save finaldata_imputed, replace

capture drop comorbid
mi passive: gen comorbid=dxHTN+dxDiabetes+CVhighChol+cvdbr

capture drop SRHg*
mi passive: gen SRHg1=.
mi passive: replace SRHg1=1 if SRH==1
mi passive: replace SRHg1=0 if SRHg1~=1 & SRH~=.
mi passive: gen SRHg2=.
mi passive: replace SRHg2=1 if SRH==2
mi passive: replace SRHg2=0 if SRHg2~=1 & SRH~=.
mi passive: gen SRHg3=.
mi passive: replace SRHg3=1 if SRH==3
mi passive: replace SRHg3=0 if SRHg3~=1 & SRH~=.

tab1 SRHg1 SRHg2 SRHg3 SRH

capture drop edubrg*
mi passive: gen edubrg1=.
mi passive: replace edubrg1=1 if edubr==1
mi passive: replace edubrg1=0 if edubrg1~=1 & edubr~=.
mi passive: gen edubrg2=.
mi passive: replace edubrg2=1 if edubr==2
mi passive: replace edubrg2=0 if edubrg2~=1 & edubr~=.
mi passive: gen edubrg3=.
mi passive: replace edubrg3=1 if edubr==3
mi passive: replace edubrg3=0 if edubrg3~=1 & edubr~=.

tab1 edubrg1 edubrg2 edubrg3 edubr

capture drop dxDiabetesg*
mi passive: gen dxDiabetesg1=.
mi passive: replace dxDiabetesg1=1 if dxDiabetes==1
mi passive: replace dxDiabetesg1=0 if dxDiabetesg1~=1 & dxDiabetes~=.
mi passive: gen dxDiabetesg2=.
mi passive: replace dxDiabetesg2=1 if dxDiabetes==2
mi passive: replace dxDiabetesg2=0 if dxDiabetesg2~=1 & dxDiabetes~=.
mi passive: gen dxDiabetesg3=.
mi passive: replace dxDiabetesg3=1 if dxDiabetes==3
mi passive: replace dxDiabetesg3=0 if dxDiabetesg3~=1 & dxDiabetes~=.

tab1 dxDiabetesg1 dxDiabetesg2 dxDiabetesg3 dxDiabetes


save finaldata_imputed_FINAL, replace

capture log close
log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\DATA_MANAGEMENT2.smcl",replace

//STEP 24: CENTER CONTINUOUS VARIABLES AND LOG TRANSFORM TRAILS//

use finaldata_imputed_FINAL,clear


**Continuous exposures and covariates**

capture drop cesvar acasiPTSDvar
foreach x of varlist CES acasiPTSD {
gen Ln`x'=ln(`x')	
}

su CES if sample_final==1 
su acasiPTSD if sample_final==1 
su invmills* if sample_final==1 

******Dietary exposures and covariates******

capture drop hei2010_total_scorecent43
gen hei2010_total_scorecent43=hei2010_total_score-43


******Other covariates*******

capture drop BMIcent30
gen BMIcent30=BMI-30

su BMIcent30 

capture drop Agecent48
gen Agecent48=Age-48

su Agecent48 

**Categorical covariates:
tab1 edubr currdrugs smokebr SRH dxHTN dxDiabetes CVhighChol cvdbr 

**Outcome variables**
su acasiPTSD*

save finaldata_imputed_FINAL,replace

**Final sample selectivity**
capture drop sample_final_part
gen sample_final_part=sample_final

mi estimate: logistic sample_final_part Age0 Sex PovStat Race 

mi estimate: logistic sample_final_part Age0  
mi estimate: logistic sample_final_part Sex  
mi estimate: logistic sample_final_part PovStat  
mi estimate: logistic sample_final_part Race  

save finaldata_imputed_FINAL,replace


//STEP 25: CREATE PTSD LOAD TERTILE//
use finaldata_imputed_FINAL,clear

capture drop PTSDtert
xtile PTSDtert=acasiPTSD,nq(3)

tab PTSDtert

bysort PTSDtert: su  acasiPTSD

save finaldata_imputed_FINAL, replace

**CREATE z-score for PTSD, CESD and all the cognitive test scores***
capture drop zacasiPTSD zCES zMMStotnorm zcvltca zCVLfrl zBVRtot zAttention zFluencyWord zDigitSpanFwd zDigitSpanBck zclock_command zLnTrailsAtestSec zLnTrailsBtestSec zCrdRot zidentpic
foreach x of varlist acasiPTSD CES MMStotnorm cvltca CVLfrl BVRtot Attention FluencyWord DigitSpanFwd DigitSpanBck clock_command LnTrailsAtestSec LnTrailsBtestSec CrdRot identpic {

mi passive: egen z`x'=std(`x') if sample_final==1

}

*************************MAIN ANALYSIS******************

capture log close
log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE_1.smcl", replace

use finaldata_imputed_FINAL,clear


//////////////////////////TABLE 1: STUDY CHARACTERISTICS OVERALL AND BY PTSD LOAD TERTILE/////////////////////////////////////

*****MAIN  TABLE ****
mi estimate: mean acasiPTSD if sample_final==1

mi estimate: prop Sex  if sample_final==1
mi estimate: mean Age0  if sample_final==1
mi estimate: prop Race  if sample_final==1
mi estimate: prop PovStat  if sample_final==1
mi estimate: prop edubrg1  if sample_final==1
mi estimate: prop edubrg3  if sample_final==1
mi estimate: prop currdrugs if sample_final==1
mi estimate: prop smokebr if sample_final==1
mi estimate: mean BMI if sample_final==1
mi estimate: mean comorbid if sample_final==1 
mi estimate: prop SRHg1 if sample_final==1
mi estimate: prop SRHg3 if sample_final==1
mi estimate: mean hei2010_total_score if sample_final==1
mi estimate: prop dxHTN if sample_final==1
mi estimate: prop dxDiabetesg3 if sample_final==1
mi estimate: prop dxDiabetesg2 if sample_final==1
mi estimate: prop CVhighChol if sample_final==1
mi estimate: prop cvdbr  if sample_final==1
mi estimate: prop rxCholesterolemia if sample_final==1
mi estimate: mean allostatic_load if sample_final==1
mi estimate: mean Energy_mean if sample_final==1
mi estimate: mean WRATtotal if sample_final==1

mi estimate: mean CES if sample_final==1
mi estimate: mean CES_DA if sample_final==1
mi estimate: mean CES_IP if sample_final==1
mi estimate: mean CES_SC if sample_final==1
mi estimate: mean CES_WB if sample_final==1

mi estimate: mean MMStotnorm if sample_final==1
mi estimate: mean cvltca if sample_final==1
mi estimate: mean CVLfrl if sample_final==1
mi estimate: mean BVRrot if sample_final==1
mi estimate: mean Attention if sample_final==1
mi estimate: mean FluencyWord if sample_final==1
mi estimate: mean DigitSpanFwd if sample_final==1
mi estimate: mean DigitSpanBck if sample_final==1
mi estimate: mean clock_command if sample_final==1
mi estimate: mean LnTrailsAtestSec if sample_final==1
mi estimate: mean LnTrailsBtestSec if sample_final==1
mi estimate: mean CrdRot if sample_final==1
mi estimate: mean identpic if sample_final==1
 
mi estimate: mean IMTmean if sample_final==1


save, replace


capture log close
log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE_1_STRATIFIED.smcl", replace

use finaldata_imputed_FINAL,clear


****************First PTSD load tertile*********************

mi estimate: mean acasiPTSD if sample_final==1 & PTSDtert==1 

mi estimate: prop Sex  if sample_final==1 & PTSDtert==1
mi estimate: mean Age0  if sample_final==1 & PTSDtert==1
mi estimate: prop Race  if sample_final==1 & PTSDtert==1
mi estimate: prop PovStat  if sample_final==1 & PTSDtert==1
mi estimate: prop edubrg1  if sample_final==1 & PTSDtert==1
mi estimate: prop edubrg3  if sample_final==1 & PTSDtert==1
mi estimate: prop currdrugs if sample_final==1 & PTSDtert==1 
mi estimate: prop smokebr if sample_final==1 & PTSDtert==1
mi estimate: mean BMI if sample_final==1 & PTSDtert==1
mi estimate: mean comorbid if sample_final==1 & PTSDtert==1
mi estimate: prop SRHg1 if sample_final==1 & PTSDtert==1
mi estimate: prop SRHg3 if sample_final==1 & PTSDtert==1
mi estimate: mean hei2010_total_score if sample_final==1 & PTSDtert==1
mi estimate: prop dxHTN if sample_final==1 & PTSDtert==1
mi estimate: prop dxDiabetesg3 if sample_final==1 & PTSDtert==1
mi estimate: prop dxDiabetesg2 if sample_final==1 & PTSDtert==1
mi estimate: prop CVhighChol  if sample_final==1 & PTSDtert==1
mi estimate: prop cvdbr  if sample_final==1 & PTSDtert==1
mi estimate: prop rxCholesterolemia if sample_final==1 & PTSDtert==1
mi estimate: mean allostatic_load if sample_final==1 & PTSDtert==1
mi estimate: mean Energy_mean if sample_final==1 & PTSDtert==1
mi estimate: mean WRATtotal if sample_final==1 & PTSDtert==1

mi estimate: mean CES if sample_final==1 & PTSDtert==1
mi estimate: mean CES_DA if sample_final==1 & PTSDtert==1
mi estimate: mean CES_IP if sample_final==1 & PTSDtert==1
mi estimate: mean CES_SC if sample_final==1 & PTSDtert==1
mi estimate: mean CES_WB if sample_final==1 & PTSDtert==1

mi estimate: mean MMStotnorm if sample_final==1 & PTSDtert==1
mi estimate: mean cvltca if sample_final==1 & PTSDtert==1
mi estimate: mean CVLfrl if sample_final==1 & PTSDtert==1
mi estimate: mean BVRrot if sample_final==1 & PTSDtert==1
mi estimate: mean Attention if sample_final==1 & PTSDtert==1
mi estimate: mean FluencyWord if sample_final==1 & PTSDtert==1
mi estimate: mean DigitSpanFwd if sample_final==1 & PTSDtert==1
mi estimate: mean DigitSpanBck if sample_final==1 & PTSDtert==1
mi estimate: mean clock_command if sample_final==1 & PTSDtert==1 
mi estimate: mean LnTrailsAtestSec if sample_final==1 & PTSDtert==1 
mi estimate: mean LnTrailsBtestSec if sample_final==1 & PTSDtert==1
mi estimate: mean CrdRot if sample_final==1 & PTSDtert==1
mi estimate: mean identpic if sample_final==1 & PTSDtert==1

mi estimate: mean IMTmean if sample_final==1 & PTSDtert==1


save, replace

****************Second PTSD load tertile*********************

mi estimate: mean acasiPTSD if sample_final==1 & PTSDtert==2

mi estimate: prop Sex  if sample_final==1 & PTSDtert==2
mi estimate: mean Age0  if sample_final==1 & PTSDtert==2
mi estimate: prop Race  if sample_final==1 & PTSDtert==2
mi estimate: prop PovStat  if sample_final==1 & PTSDtert==2
mi estimate: prop edubrg1  if sample_final==1 & PTSDtert==2
mi estimate: prop edubrg3  if sample_final==1 & PTSDtert==2
mi estimate: prop currdrugs if sample_final==1 & PTSDtert==2 
mi estimate: prop smokebr if sample_final==1 & PTSDtert==2
mi estimate: mean BMI if sample_final==1 & PTSDtert==2
mi estimate: mean comorbid if sample_final==1 & PTSDtert==2
mi estimate: prop SRHg1 if sample_final==1 & PTSDtert==2
mi estimate: prop SRHg3 if sample_final==1 & PTSDtert==2
mi estimate: mean hei2010_total_score if sample_final==1 & PTSDtert==2
mi estimate: prop dxHTN if sample_final==1 & PTSDtert==2
mi estimate: prop dxDiabetesg3 if sample_final==1 & PTSDtert==2
mi estimate: prop dxDiabetesg2 if sample_final==1 & PTSDtert==2
mi estimate: prop CVhighChol  if sample_final==1 & PTSDtert==2
mi estimate: prop cvdbr if sample_final==1 & PTSDtert==2
mi estimate: prop rxCholesterolemia if sample_final==1 & PTSDtert==2
mi estimate: mean allostatic_load if sample_final==1 & PTSDtert==2
mi estimate: mean Energy_mean if sample_final==1 & PTSDtert==2
mi estimate: mean WRATtotal if sample_final==1 & PTSDtert==2

mi estimate: mean CES if sample_final==1 & PTSDtert==2
mi estimate: mean CES_DA if sample_final==1 & PTSDtert==2
mi estimate: mean CES_IP if sample_final==1 & PTSDtert==2
mi estimate: mean CES_SC if sample_final==1 & PTSDtert==2
mi estimate: mean CES_WB if sample_final==1 & PTSDtert==2

mi estimate: mean MMStotnorm if sample_final==1 & PTSDtert==2
mi estimate: mean cvltca if sample_final==1 & PTSDtert==2
mi estimate: mean CVLfrl if sample_final==1 & PTSDtert==2
mi estimate: mean BVRrot if sample_final==1 & PTSDtert==2
mi estimate: mean Attention if sample_final==1 & PTSDtert==2
mi estimate: mean FluencyWord if sample_final==1 & PTSDtert==2
mi estimate: mean DigitSpanFwd if sample_final==1 & PTSDtert==2
mi estimate: mean DigitSpanBck if sample_final==1 & PTSDtert==2
mi estimate: mean clock_command if sample_final==1 & PTSDtert==2 
mi estimate: mean LnTrailsAtestSec if sample_final==1 & PTSDtert==2 
mi estimate: mean LnTrailsBtestSec if sample_final==1 & PTSDtert==2
mi estimate: mean CrdRot if sample_final==1 & PTSDtert==2
mi estimate: mean identpic if sample_final==1 & PTSDtert==2

mi estimate: mean IMTmean if sample_final==1 & PTSDtert==2


save, replace

****************Third PTSD load tertile*********************

mi estimate: mean acasiPTSD if sample_final==1 & PTSDtert==3

mi estimate: prop Sex  if sample_final==1 & PTSDtert==3
mi estimate: mean Age0  if sample_final==1 & PTSDtert==3
mi estimate: prop Race  if sample_final==1 & PTSDtert==3
mi estimate: prop PovStat  if sample_final==1 & PTSDtert==3
mi estimate: prop edubrg1  if sample_final==1 & PTSDtert==3
mi estimate: prop edubrg3  if sample_final==1 & PTSDtert==3
mi estimate: prop currdrugs if sample_final==1 & PTSDtert==3 
mi estimate: prop smokebr if sample_final==1 & PTSDtert==3
mi estimate: mean BMI if sample_final==1 & PTSDtert==3
mi estimate: mean comorbid if sample_final==1 & PTSDtert==3
mi estimate: prop SRHg1 if sample_final==1 & PTSDtert==3
mi estimate: prop SRHg3 if sample_final==1 & PTSDtert==3
mi estimate: mean hei2010_total_score if sample_final==1 & PTSDtert==3
mi estimate: prop dxHTN if sample_final==1 & PTSDtert==3
mi estimate: prop dxDiabetesg3 if sample_final==1 & PTSDtert==3
mi estimate: prop dxDiabetesg2 if sample_final==1 & PTSDtert==3
mi estimate: prop CVhighChol  if sample_final==1 & PTSDtert==3
mi estimate: prop cvdbr if sample_final==1 & PTSDtert==3
mi estimate: prop rxCholesterolemia if sample_final==1 & PTSDtert==3
mi estimate: mean allostatic_load if sample_final==1 & PTSDtert==3
mi estimate: mean Energy_mean if sample_final==1 & PTSDtert==3
mi estimate: mean WRATtotal if sample_final==1 & PTSDtert==3

mi estimate: mean CES if sample_final==1 & PTSDtert==3
mi estimate: mean CES_DA if sample_final==1 & PTSDtert==3
mi estimate: mean CES_IP if sample_final==1 & PTSDtert==3
mi estimate: mean CES_SC if sample_final==1 & PTSDtert==3
mi estimate: mean CES_WB if sample_final==1 & PTSDtert==3

mi estimate: mean MMStotnorm if sample_final==1 & PTSDtert==3
mi estimate: mean cvltca if sample_final==1 & PTSDtert==3
mi estimate: mean CVLfrl if sample_final==1 & PTSDtert==3
mi estimate: mean BVRrot if sample_final==1 & PTSDtert==3
mi estimate: mean Attention if sample_final==1 & PTSDtert==3
mi estimate: mean FluencyWord if sample_final==1 & PTSDtert==3
mi estimate: mean DigitSpanFwd if sample_final==1 & PTSDtert==3
mi estimate: mean DigitSpanBck if sample_final==1 & PTSDtert==3
mi estimate: mean clock_command if sample_final==1 & PTSDtert==3 
mi estimate: mean LnTrailsAtestSec if sample_final==1 & PTSDtert==3 
mi estimate: mean LnTrailsBtestSec if sample_final==1 & PTSDtert==3
mi estimate: mean CrdRot if sample_final==1 & PTSDtert==3
mi estimate: mean identpic if sample_final==1 & PTSDtert==3

mi estimate: mean IMTmean if sample_final==1 & PTSDtert==3


save, replace


*********************DIFFERENCE BY PTSD load tertiles**************************

mi estimate: reg acasiPTSD i.PTSDtert if sample_final==1

mi estimate: mlogit Sex i.PTSDtert  if sample_final==1
mi estimate: reg Age0  i.PTSDtert  if sample_final==1
mi estimate: mlogit Race  i.PTSDtert if sample_final==1
mi estimate: mlogit PovStat  i.PTSDtert if sample_final==1
mi estimate: mlogit edubrg1  i.PTSDtert if sample_final==1
mi estimate: mlogit edubrg3  i.PTSDtert if sample_final==1
mi estimate: mlogit currdrugs i.PTSDtert if sample_final==1
mi estimate: mlogit smokebr i.PTSDtert if sample_final==1
mi estimate: reg BMI i.PTSDtert if sample_final==1
mi estimate: reg comorbid i.PTSDtert if sample_final==1
mi estimate: mlogit SRHg1 i.PTSDtert if sample_final==1
mi estimate: mlogit SRHg3 i.PTSDtert if sample_final==1
mi estimate: reg hei2010_total_score i.PTSDtert if sample_final==1
mi estimate: mlogit dxHTN i.PTSDtert if sample_final==1
mi estimate: mlogit dxDiabetesg3 i.PTSDtert if sample_final==1
mi estimate: mlogit dxDiabetesg2 i.PTSDtert if sample_final==1
mi estimate: mlogit CVhighChol  i.PTSDtert if sample_final==1
mi estimate: mlogit cvdbr  i.PTSDtert if sample_final==1


mi estimate: reg CES i.PTSDtert if sample_final==1
mi estimate: reg CES_DA i.PTSDtert if sample_final==1  
mi estimate: reg CES_IP i.PTSDtert if sample_final==1
mi estimate: reg CES_SC i.PTSDtert if sample_final==1 
mi estimate: reg CES_WB i.PTSDtert if sample_final==1
mi estimate: reg rxCholesterolemia i.PTSDtert if sample_final==1
mi estimate: reg allostatic_load i.PTSDtert if sample_final==1
mi estimate: reg Energy_mean i.PTSDtert if sample_final==1
mi estimate: reg WRATtotal i.PTSDtert if sample_final==1

 
mi estimate: reg MMStotnorm i.PTSDtert if sample_final==1 
mi estimate: reg cvltca i.PTSDtert if sample_final==1
mi estimate: reg CVLfrl i.PTSDtert if sample_final==1
mi estimate: reg BVRrot i.PTSDtert if sample_final==1
mi estimate: reg Attention i.PTSDtert if sample_final==1 
mi estimate: reg FluencyWord i.PTSDtert if sample_final==1 
mi estimate: reg DigitSpanFwd i.PTSDtert if sample_final==1
mi estimate: reg DigitSpanBck i.PTSDtert if sample_final==1
mi estimate: reg clock_command i.PTSDtert if sample_final==1
mi estimate: reg LnTrailsAtestSec i.PTSDtert if sample_final==1
mi estimate: reg LnTrailsBtestSec i.PTSDtert if sample_final==1
mi estimate: reg CrdRot i.PTSDtert if sample_final==1
mi estimate: reg identpic i.PTSDtert if sample_final==1

mi estimate: reg IMTmean i.PTSDtert if sample_final==1



save, replace

***********************Difference by PTSD load tertile, Age0, Sex, Race and poverty status-adjusted*******************

mi estimate: reg acasiPTSD i.PTSDtert Age0 Race Sex PovStat if sample_final==1

mi estimate: mlogit Sex i.PTSDtert Age0 Race PovStat if sample_final==1  
mi estimate: reg Age0 i.PTSDtert Race Sex PovStat if sample_final==1
mi estimate: mlogit Race  i.PTSDtert Age0 Sex PovStat if sample_final==1
mi estimate: mlogit PovStat  i.PTSDtert Age0 Race Sex  if sample_final==1
mi estimate: mlogit edubrg1  i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit edubrg3  i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit currdrugs i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit smokebr i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg BMI i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg comorbid i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit SRHg1 i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit SRHg3 i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg hei2010_total_score i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit dxHTN i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit dxDiabetesg3 i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit dxDiabetesg2 i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit CVhighChol  i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: mlogit cvdbr  i.PTSDtert Age0 Race Sex PovStat if sample_final==1

mi estimate: reg CES i.PTSDtert Age0 Race Sex PovStat if sample_final==1 
mi estimate: reg CES_DA i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg CES_IP i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg CES_SC i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg CES_WB i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg rxCholesterolemia i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg allostatic_load i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg Energy_mean i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg WRATtotal i.PTSDtert Age0 Race Sex PovStat if sample_final==1
 
mi estimate: reg MMStotnorm i.PTSDtert Age0 Race Sex PovStat if sample_final==1 
mi estimate: reg cvltca i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg CVLfrl i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg BVRrot i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg Attention i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg FluencyWord i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg DigitSpanFwd i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg DigitSpanBck i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg clock_command i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg LnTrailsAtestSec i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg LnTrailsBtestSec i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg CrdRot i.PTSDtert Age0 Race Sex PovStat if sample_final==1
mi estimate: reg identpic i.PTSDtert Age0 Race Sex PovStat if sample_final==1

mi estimate: reg IMTmean i.PTSDtert Age0 Race Sex PovStat if sample_final==1


save, replace



capture log close
log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE_2.smcl", replace

use finaldata_imputed_FINAL,clear


***LINEAR REGRESSION MODELS OF PTSD AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS of PTSD AND CES; MODLE 1***

mi estimate: reg CES acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CES_DA acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CES_IP acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CES_SC acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CES_WB acasiPTSD Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic CES Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot CES Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_DA AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot CES_DA Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_IP AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot CES_IP Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_SC AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot CES_SC Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_WB AND COGNITION; MODLE 1***
mi estimate: reg MMStotnorm CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg cvltca CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CVLfrl CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg BVRtot CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg Attention CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg FluencyWord CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg clock_command CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg identpic CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

mi estimate: reg CrdRot CES_WB Age0 i.Race PovStat Sex invmills if sample_final==1

***LINEAR REGRESSION MODELS OF PTSD AND COGNITION; MODLE 2 includes edubrg1 edubrg3 WRATtotal***
mi estimate: reg MMStotnorm acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg clock_command acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1


***LINEAR REGRESSION MODELS of PTSD AND CES; MODLE 2 INCLUDES edubrg1 edubrg3 WRATtotal***

mi estimate: reg CES acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CES_DA acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CES_IP acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CES_SC acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CES_WB acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES AND COGNITION; MODLE 2***
mi estimate: reg MMStotnorm CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg clock_command CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_DA AND COGNITION; MODLE 2***
mi estimate: reg MMStotnorm CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1
mi estimate: reg clock_command CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_IP AND COGNITION; MODLE 2***
mi estimate: reg MMStotnorm CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg clock_command CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_SC AND COGNITION; MODLE 2***
mi estimate: reg MMStotnorm CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg clock_command CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_WB AND COGNITION; MODLE 2***
mi estimate: reg MMStotnorm CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg cvltca CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CVLfrl CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg BVRtot CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg Attention CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg FluencyWord CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg clock_command CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg identpic CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

mi estimate: reg CrdRot CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal invmills if sample_final==1

***LINEAR REGRESSION MODELS OF PTSD AND COGNITION; MODLE 3 INCLUDES LIFESTYLE FACTORS***
mi estimate: reg MMStotnorm acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3  WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg clock_command acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS of PTSD AND CES; MODLE 3 LIFESTYLE FACTORS

mi estimate: reg CES acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CES_DA acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CES_IP acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CES_SC acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CES_WB acasiPTSD Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES AND COGNITION; MODLE 3***
mi estimate: reg MMStotnorm CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg clock_command CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot CES Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_DA AND COGNITION; MODLE 3***
mi estimate: reg MMStotnorm CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1
mi estimate: reg clock_command CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot CES_DA Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_IP AND COGNITION; MODLE 3***
mi estimate: reg MMStotnorm CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg clock_command CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot CES_IP Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_SC AND COGNITION; MODLE 3***
mi estimate: reg MMStotnorm CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg clock_command CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot CES_SC Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_WB AND COGNITION; MODLE 3***
mi estimate: reg MMStotnorm CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg cvltca CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CVLfrl CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg BVRtot CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg Attention CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg FluencyWord CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg clock_command CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg identpic CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1

mi estimate: reg CrdRot CES_WB Age0 i.Race PovStat Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr invmills if sample_final==1


***LINEAR REGRESSION MODELS OF PTSD AND COGNITION; MODLE 4 INCLUDES HEALTH-RELATED FACTORS***
mi estimate: reg MMStotnorm acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS of PTSD AND CES; MODLE 4 INCLUDES HEALTH-RELATED FACTORS***

mi estimate: reg CES acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CES_DA acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CES_IP acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CES_SC acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CES_WB acasiPTSD Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES AND COGNITION; MODLE 4***
mi estimate: reg MMStotnorm CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot CES Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_DA AND COGNITION; MODLE 4***
mi estimate: reg MMStotnorm CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot CES_DA Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_IP AND COGNITION; MODLE 4***
mi estimate: reg MMStotnorm CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot CES_IP Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_SC AND COGNITION; MODLE 4***
mi estimate: reg MMStotnorm CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot CES_SC Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

***LINEAR REGRESSION MODELS OF CES_WB AND COGNITION; MODLE 4***
mi estimate: reg MMStotnorm CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg cvltca CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CVLfrl CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg BVRtot CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg Attention CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg FluencyWord CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanFwd CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg DigitSpanBck CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg clock_command CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsAtestSec CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg LnTrailsBtestSec CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg identpic CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

mi estimate: reg CrdRot CES_WB Age0 i.Race i.PovStat i.Sex edubrg1 edubrg3 WRATtotal i.currdrugs i.smokebr comorbid hei2010_total_score Energy_mean SRHg1 SRHg3 allostatic_load IMTmean invmills if sample_final==1

capture log close
log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE_3.smcl", replace
use finaldata_imputed_FINAL,clear

**CREATE z-score for PTSD, CESD and all the cognitive test scores***
capture drop zacasiPTSD zCES zMMStotnorm zcvltca zCVLfrl zBVRtot zAttention zFluencyWord zDigitSpanFwd zDigitSpanBck zclock_command zLnTrailsAtestSec zLnTrailsBtestSec zCrdRot zidentpic
foreach x of varlist acasiPTSD CES MMStotnorm cvltca CVLfrl BVRtot Attention FluencyWord DigitSpanFwd DigitSpanBck clock_command LnTrailsAtestSec LnTrailsBtestSec CrdRot identpic {

mi passive: egen z`x'=std(`x') if sample_final==1

}

***mi xeq for zMMStotnorm***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zMMStotnorm,) (zacasiPTSD -> zCES,) (zCES -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (Age0-> zMMStotnorm,)(Sex-> zMMStotnorm,) (Race -> zMMStotnorm, ) (PovStat -> zMMStotnorm,)(edubrg1-> zMMStotnorm,) (edubrg3-> zMMStotnorm,) (smokebr -> zMMStotnorm,) (currdrugs -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (hei2010_total_score -> zMMStotnorm,) (Energy_mean -> zMMStotnorm,) (zCES -> zMMStotnorm) (WRATtotal-> zMMStotnorm,) (SRHg1-> zMMStotnorm,) (BMI-> zMMStotnorm,) (comorbid-> zMMStotnorm,)  (allostatic_load-> zMMStotnorm,) (IMTmean-> zMMStotnorm,) (invmillsfinal -> zMMStotnorm,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zMMStotnorm,) (zacasiPTSD -> zCES,) (zCES -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (Age0-> zMMStotnorm,)(Sex-> zMMStotnorm,) (Race -> zMMStotnorm, ) (PovStat -> zMMStotnorm,)(edubrg1-> zMMStotnorm,) (edubrg3-> zMMStotnorm,) (smokebr -> zMMStotnorm,) (currdrugs -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (hei2010_total_score -> zMMStotnorm,) (Energy_mean -> zMMStotnorm,) (zCES -> zMMStotnorm) (WRATtotal-> zMMStotnorm,) (SRHg1-> zMMStotnorm,) (BMI-> zMMStotnorm,) (comorbid-> zMMStotnorm,)  (allostatic_load-> zMMStotnorm,) (IMTmean-> zMMStotnorm,) (invmillsfinal -> zMMStotnorm,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zMMStotnorm,) (zacasiPTSD -> zCES,) (zCES -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (Age0-> zMMStotnorm,)(Sex-> zMMStotnorm,) (Race -> zMMStotnorm, ) (PovStat -> zMMStotnorm,)(edubrg1-> zMMStotnorm,) (edubrg3-> zMMStotnorm,) (smokebr -> zMMStotnorm,) (currdrugs -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (hei2010_total_score -> zMMStotnorm,) (Energy_mean -> zMMStotnorm,) (zCES -> zMMStotnorm) (WRATtotal-> zMMStotnorm,) (SRHg1-> zMMStotnorm,) (BMI-> zMMStotnorm,) (comorbid-> zMMStotnorm,)  (allostatic_load-> zMMStotnorm,) (IMTmean-> zMMStotnorm,) (invmillsfinal -> zMMStotnorm,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zMMStotnorm,) (zacasiPTSD -> zCES,) (zCES -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (Age0-> zMMStotnorm,)(Sex-> zMMStotnorm,) (Race -> zMMStotnorm, ) (PovStat -> zMMStotnorm,)(edubrg1-> zMMStotnorm,) (edubrg3-> zMMStotnorm,) (smokebr -> zMMStotnorm,) (currdrugs -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (hei2010_total_score -> zMMStotnorm,) (Energy_mean -> zMMStotnorm,) (zCES -> zMMStotnorm) (WRATtotal-> zMMStotnorm,) (SRHg1-> zMMStotnorm,) (BMI-> zMMStotnorm,) (comorbid-> zMMStotnorm,)  (allostatic_load-> zMMStotnorm,) (IMTmean-> zMMStotnorm,) (invmillsfinal -> zMMStotnorm,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zMMStotnorm,) (zacasiPTSD -> zCES,) (zCES -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (Age0-> zMMStotnorm,)(Sex-> zMMStotnorm,) (Race -> zMMStotnorm, ) (PovStat -> zMMStotnorm,)(edubrg1-> zMMStotnorm,) (edubrg3-> zMMStotnorm,) (smokebr -> zMMStotnorm,) (currdrugs -> zMMStotnorm,) (zacasiPTSD -> zMMStotnorm,) (hei2010_total_score -> zMMStotnorm,) (Energy_mean -> zMMStotnorm,) (zCES -> zMMStotnorm) (WRATtotal-> zMMStotnorm,) (SRHg1-> zMMStotnorm,) (BMI-> zMMStotnorm,) (comorbid-> zMMStotnorm,)  (allostatic_load-> zMMStotnorm,) (IMTmean-> zMMStotnorm,) (invmillsfinal -> zMMStotnorm,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects


*** mi xeq for zcvltca***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zcvltca,) (zacasiPTSD -> zCES,) (zCES -> zcvltca,) (zacasiPTSD -> zcvltca,) (Age0-> zcvltca,)(Sex-> zcvltca,) (Race -> zcvltca, ) (PovStat -> zcvltca,) (edubrg1-> zcvltca,) (edubrg3-> zcvltca,) (smokebr -> zcvltca,) (currdrugs -> zcvltca,) (zacasiPTSD -> zcvltca,) (hei2010_total_score -> zcvltca,) (Energy_mean -> zcvltca,) (zCES -> zcvltca) (WRATtotal-> zcvltca,) (SRHg1-> zcvltca,) (SRHg3-> zcvltca,) (BMI-> zcvltca,) (comorbid-> zcvltca,)  (allostatic_load-> zcvltca,) (IMTmean-> zcvltca,) (invmillsfinal -> zcvltca,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zcvltca,) (zacasiPTSD -> zCES,) (zCES -> zcvltca,) (zacasiPTSD -> zcvltca,) (Age0-> zcvltca,)(Sex-> zcvltca,) (Race -> zcvltca, ) (PovStat -> zcvltca,) (edubrg1-> zcvltca,) (edubrg3-> zcvltca,) (smokebr -> zcvltca,) (currdrugs -> zcvltca,) (zacasiPTSD -> zcvltca,) (hei2010_total_score -> zcvltca,) (Energy_mean -> zcvltca,) (zCES -> zcvltca) (WRATtotal-> zcvltca,) (SRHg1-> zcvltca,) (SRHg3-> zcvltca,) (BMI-> zcvltca,) (comorbid-> zcvltca,)  (allostatic_load-> zcvltca,) (IMTmean-> zcvltca,) (invmillsfinal -> zcvltca,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zcvltca,) (zacasiPTSD -> zCES,) (zCES -> zcvltca,) (zacasiPTSD -> zcvltca,) (Age0-> zcvltca,)(Sex-> zcvltca,) (Race -> zcvltca, ) (PovStat -> zcvltca,) (edubrg1-> zcvltca,) (edubrg3-> zcvltca,) (smokebr -> zcvltca,) (currdrugs -> zcvltca,) (zacasiPTSD -> zcvltca,) (hei2010_total_score -> zcvltca,) (Energy_mean -> zcvltca,) (zCES -> zcvltca) (WRATtotal-> zcvltca,) (SRHg1-> zcvltca,) (SRHg3-> zcvltca,) (BMI-> zcvltca,) (comorbid-> zcvltca,)  (allostatic_load-> zcvltca,) (IMTmean-> zcvltca,) (invmillsfinal -> zcvltca,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zcvltca,) (zacasiPTSD -> zCES,) (zCES -> zcvltca,) (zacasiPTSD -> zcvltca,) (Age0-> zcvltca,)(Sex-> zcvltca,) (Race -> zcvltca, ) (PovStat -> zcvltca,) (edubrg1-> zcvltca,) (edubrg3-> zcvltca,) (smokebr -> zcvltca,) (currdrugs -> zcvltca,) (zacasiPTSD -> zcvltca,) (hei2010_total_score -> zcvltca,) (Energy_mean -> zcvltca,) (zCES -> zcvltca) (WRATtotal-> zcvltca,) (SRHg1-> zcvltca,) (SRHg3-> zcvltca,) (BMI-> zcvltca,) (comorbid-> zcvltca,)  (allostatic_load-> zcvltca,) (IMTmean-> zcvltca,) (invmillsfinal -> zcvltca,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zcvltca,) (zacasiPTSD -> zCES,) (zCES -> zcvltca,) (zacasiPTSD -> zcvltca,) (Age0-> zcvltca,)(Sex-> zcvltca,) (Race -> zcvltca, ) (PovStat -> zcvltca,) (edubrg1-> zcvltca,) (edubrg3-> zcvltca,) (smokebr -> zcvltca,) (currdrugs -> zcvltca,) (zacasiPTSD -> zcvltca,) (hei2010_total_score -> zcvltca,) (Energy_mean -> zcvltca,) (zCES -> zcvltca) (WRATtotal-> zcvltca,) (SRHg1-> zcvltca,) (SRHg3-> zcvltca,) (BMI-> zcvltca,) (comorbid-> zcvltca,)  (allostatic_load-> zcvltca,) (IMTmean-> zcvltca,) (invmillsfinal -> zcvltca,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

*** mi xeq for zCVLfrl***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCVLfrl,) (zacasiPTSD -> zCES,) (zCES -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (Age0-> zCVLfrl,)(Sex-> zCVLfrl,) (Race -> zCVLfrl, ) (PovStat -> zCVLfrl,) (edubrg1-> zCVLfrl,) (edubrg3-> zCVLfrl,) (smokebr -> zCVLfrl,) (currdrugs -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (hei2010_total_score -> zCVLfrl,) (Energy_mean -> zCVLfrl,) (zCES -> zCVLfrl) (WRATtotal-> zCVLfrl,) (SRHg1-> zCVLfrl,) (SRHg3-> zCVLfrl,) (BMI-> zCVLfrl,) (comorbid-> zCVLfrl,)  (allostatic_load-> zCVLfrl,) (IMTmean-> zCVLfrl,) (invmillsfinal -> zCVLfrl,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCVLfrl,) (zacasiPTSD -> zCES,) (zCES -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (Age0-> zCVLfrl,)(Sex-> zCVLfrl,) (Race -> zCVLfrl, ) (PovStat -> zCVLfrl,) (edubrg1-> zCVLfrl,) (edubrg3-> zCVLfrl,) (smokebr -> zCVLfrl,) (currdrugs -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (hei2010_total_score -> zCVLfrl,) (Energy_mean -> zCVLfrl,) (zCES -> zCVLfrl) (WRATtotal-> zCVLfrl,) (SRHg1-> zCVLfrl,) (SRHg3-> zCVLfrl,) (BMI-> zCVLfrl,) (comorbid-> zCVLfrl,)  (allostatic_load-> zCVLfrl,) (IMTmean-> zCVLfrl,) (invmillsfinal -> zCVLfrl,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCVLfrl,) (zacasiPTSD -> zCES,) (zCES -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (Age0-> zCVLfrl,)(Sex-> zCVLfrl,) (Race -> zCVLfrl, ) (PovStat -> zCVLfrl,) (edubrg1-> zCVLfrl,) (edubrg3-> zCVLfrl,) (smokebr -> zCVLfrl,) (currdrugs -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (hei2010_total_score -> zCVLfrl,) (Energy_mean -> zCVLfrl,) (zCES -> zCVLfrl) (WRATtotal-> zCVLfrl,) (SRHg1-> zCVLfrl,) (SRHg3-> zCVLfrl,) (BMI-> zCVLfrl,) (comorbid-> zCVLfrl,)  (allostatic_load-> zCVLfrl,) (IMTmean-> zCVLfrl,) (invmillsfinal -> zCVLfrl,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCVLfrl,) (zacasiPTSD -> zCES,) (zCES -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (Age0-> zCVLfrl,)(Sex-> zCVLfrl,) (Race -> zCVLfrl, ) (PovStat -> zCVLfrl,) (edubrg1-> zCVLfrl,) (edubrg3-> zCVLfrl,) (smokebr -> zCVLfrl,) (currdrugs -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (hei2010_total_score -> zCVLfrl,) (Energy_mean -> zCVLfrl,) (zCES -> zCVLfrl) (WRATtotal-> zCVLfrl,) (SRHg1-> zCVLfrl,) (SRHg3-> zCVLfrl,) (BMI-> zCVLfrl,) (comorbid-> zCVLfrl,)  (allostatic_load-> zCVLfrl,) (IMTmean-> zCVLfrl,) (invmillsfinal -> zCVLfrl,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCVLfrl,) (zacasiPTSD -> zCES,) (zCES -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (Age0-> zCVLfrl,)(Sex-> zCVLfrl,) (Race -> zCVLfrl, ) (PovStat -> zCVLfrl,) (edubrg1-> zCVLfrl,) (edubrg3-> zCVLfrl,) (smokebr -> zCVLfrl,) (currdrugs -> zCVLfrl,) (zacasiPTSD -> zCVLfrl,) (hei2010_total_score -> zCVLfrl,) (Energy_mean -> zCVLfrl,) (zCES -> zCVLfrl) (WRATtotal-> zCVLfrl,) (SRHg1-> zCVLfrl,) (SRHg3-> zCVLfrl,) (BMI-> zCVLfrl,) (comorbid-> zCVLfrl,)  (allostatic_load-> zCVLfrl,) (IMTmean-> zCVLfrl,) (invmillsfinal -> zCVLfrl,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

*** mi xeq for zBVRtot***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zBVRtot,) (zacasiPTSD -> zCES,) (zCES -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (Age0-> zBVRtot,)(Sex-> zBVRtot,) (Race -> zBVRtot, ) (PovStat -> zBVRtot,) (edubrg1-> zBVRtot,) (edubrg3-> zBVRtot,) (smokebr -> zBVRtot,) (currdrugs -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (hei2010_total_score -> zBVRtot,) (Energy_mean -> zBVRtot,) (zCES -> zBVRtot) (WRATtotal-> zBVRtot,) (SRHg1-> zBVRtot,) (SRHg3-> zBVRtot,) (BMI-> zBVRtot,) (comorbid-> zBVRtot,)  (allostatic_load-> zBVRtot,) (IMTmean-> zBVRtot,) (invmillsfinal -> zBVRtot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zBVRtot,) (zacasiPTSD -> zCES,) (zCES -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (Age0-> zBVRtot,)(Sex-> zBVRtot,) (Race -> zBVRtot, ) (PovStat -> zBVRtot,) (edubrg1-> zBVRtot,) (edubrg3-> zBVRtot,) (smokebr -> zBVRtot,) (currdrugs -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (hei2010_total_score -> zBVRtot,) (Energy_mean -> zBVRtot,) (zCES -> zBVRtot) (WRATtotal-> zBVRtot,) (SRHg1-> zBVRtot,) (SRHg3-> zBVRtot,) (BMI-> zBVRtot,) (comorbid-> zBVRtot,)  (allostatic_load-> zBVRtot,) (IMTmean-> zBVRtot,) (invmillsfinal -> zBVRtot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zBVRtot,) (zacasiPTSD -> zCES,) (zCES -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (Age0-> zBVRtot,)(Sex-> zBVRtot,) (Race -> zBVRtot, ) (PovStat -> zBVRtot,) (edubrg1-> zBVRtot,) (edubrg3-> zBVRtot,) (smokebr -> zBVRtot,) (currdrugs -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (hei2010_total_score -> zBVRtot,) (Energy_mean -> zBVRtot,) (zCES -> zBVRtot) (WRATtotal-> zBVRtot,) (SRHg1-> zBVRtot,) (SRHg3-> zBVRtot,) (BMI-> zBVRtot,) (comorbid-> zBVRtot,)  (allostatic_load-> zBVRtot,) (IMTmean-> zBVRtot,) (invmillsfinal -> zBVRtot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zBVRtot,) (zacasiPTSD -> zCES,) (zCES -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (Age0-> zBVRtot,)(Sex-> zBVRtot,) (Race -> zBVRtot, ) (PovStat -> zBVRtot,) (edubrg1-> zBVRtot,) (edubrg3-> zBVRtot,) (smokebr -> zBVRtot,) (currdrugs -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (hei2010_total_score -> zBVRtot,) (Energy_mean -> zBVRtot,) (zCES -> zBVRtot) (WRATtotal-> zBVRtot,) (SRHg1-> zBVRtot,) (SRHg3-> zBVRtot,) (BMI-> zBVRtot,) (comorbid-> zBVRtot,)  (allostatic_load-> zBVRtot,) (IMTmean-> zBVRtot,) (invmillsfinal -> zBVRtot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zBVRtot,) (zacasiPTSD -> zCES,) (zCES -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (Age0-> zBVRtot,)(Sex-> zBVRtot,) (Race -> zBVRtot, ) (PovStat -> zBVRtot,) (edubrg1-> zBVRtot,) (edubrg3-> zBVRtot,) (smokebr -> zBVRtot,) (currdrugs -> zBVRtot,) (zacasiPTSD -> zBVRtot,) (hei2010_total_score -> zBVRtot,) (Energy_mean -> zBVRtot,) (zCES -> zBVRtot) (WRATtotal-> zBVRtot,) (SRHg1-> zBVRtot,) (SRHg3-> zBVRtot,) (BMI-> zBVRtot,) (comorbid-> zBVRtot,)  (allostatic_load-> zBVRtot,) (IMTmean-> zBVRtot,) (invmillsfinal -> zBVRtot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

*** mi xeq for zAttention***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zAttention,) (zacasiPTSD -> zCES,) (zCES -> zAttention,) (zacasiPTSD -> zAttention,) (Age0-> zAttention,)(Sex-> zAttention,) (Race -> zAttention, ) (PovStat -> zAttention,) (edubrg1-> zAttention,) (edubrg3-> zAttention,) (smokebr -> zAttention,) (currdrugs -> zAttention,) (zacasiPTSD -> zAttention,) (hei2010_total_score -> zAttention,) (Energy_mean -> zAttention,) (zCES -> zAttention) (WRATtotal-> zAttention,) (SRHg1-> zAttention,) (SRHg3-> zAttention,) (BMI-> zAttention,) (comorbid-> zAttention,)  (allostatic_load-> zAttention,) (IMTmean-> zAttention,) (invmillsfinal -> zAttention,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zAttention,) (zacasiPTSD -> zCES,) (zCES -> zAttention,) (zacasiPTSD -> zAttention,) (Age0-> zAttention,)(Sex-> zAttention,) (Race -> zAttention, ) (PovStat -> zAttention,) (edubrg1-> zAttention,) (edubrg3-> zAttention,) (smokebr -> zAttention,) (currdrugs -> zAttention,) (zacasiPTSD -> zAttention,) (hei2010_total_score -> zAttention,) (Energy_mean -> zAttention,) (zCES -> zAttention) (WRATtotal-> zAttention,) (SRHg1-> zAttention,) (SRHg3-> zAttention,) (BMI-> zAttention,) (comorbid-> zAttention,)  (allostatic_load-> zAttention,) (IMTmean-> zAttention,) (invmillsfinal -> zAttention,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zAttention,) (zacasiPTSD -> zCES,) (zCES -> zAttention,) (zacasiPTSD -> zAttention,) (Age0-> zAttention,)(Sex-> zAttention,) (Race -> zAttention, ) (PovStat -> zAttention,) (edubrg1-> zAttention,) (edubrg3-> zAttention,) (smokebr -> zAttention,) (currdrugs -> zAttention,) (zacasiPTSD -> zAttention,) (hei2010_total_score -> zAttention,) (Energy_mean -> zAttention,) (zCES -> zAttention) (WRATtotal-> zAttention,) (SRHg1-> zAttention,) (SRHg3-> zAttention,) (BMI-> zAttention,) (comorbid-> zAttention,)  (allostatic_load-> zAttention,) (IMTmean-> zAttention,) (invmillsfinal -> zAttention,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zAttention,) (zacasiPTSD -> zCES,) (zCES -> zAttention,) (zacasiPTSD -> zAttention,) (Age0-> zAttention,)(Sex-> zAttention,) (Race -> zAttention, ) (PovStat -> zAttention,) (edubrg1-> zAttention,) (edubrg3-> zAttention,) (smokebr -> zAttention,) (currdrugs -> zAttention,) (zacasiPTSD -> zAttention,) (hei2010_total_score -> zAttention,) (Energy_mean -> zAttention,) (zCES -> zAttention) (WRATtotal-> zAttention,) (SRHg1-> zAttention,) (SRHg3-> zAttention,) (BMI-> zAttention,) (comorbid-> zAttention,)  (allostatic_load-> zAttention,) (IMTmean-> zAttention,) (invmillsfinal -> zAttention,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zAttention,) (zacasiPTSD -> zCES,) (zCES -> zAttention,) (zacasiPTSD -> zAttention,) (Age0-> zAttention,)(Sex-> zAttention,) (Race -> zAttention, ) (PovStat -> zAttention,) (edubrg1-> zAttention,) (edubrg3-> zAttention,) (smokebr -> zAttention,) (currdrugs -> zAttention,) (zacasiPTSD -> zAttention,) (hei2010_total_score -> zAttention,) (Energy_mean -> zAttention,) (zCES -> zAttention) (WRATtotal-> zAttention,) (SRHg1-> zAttention,) (SRHg3-> zAttention,) (BMI-> zAttention,) (comorbid-> zAttention,)  (allostatic_load-> zAttention,) (IMTmean-> zAttention,) (invmillsfinal -> zAttention,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zFluencyWord***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zFluencyWord,) (zacasiPTSD -> zCES,) (zCES -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (Age0-> zFluencyWord,)(Sex-> zFluencyWord,) (Race -> zFluencyWord, ) (PovStat -> zFluencyWord,) (edubrg1-> zFluencyWord,) (edubrg3-> zFluencyWord,) (smokebr -> zFluencyWord,) (currdrugs -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (hei2010_total_score -> zFluencyWord,) (Energy_mean -> zFluencyWord,) (zCES -> zFluencyWord) (WRATtotal-> zFluencyWord,) (SRHg1-> zFluencyWord,) (SRHg3-> zFluencyWord,) (BMI-> zFluencyWord,) (comorbid-> zFluencyWord,)  (allostatic_load-> zFluencyWord,) (IMTmean-> zFluencyWord,) (invmillsfinal -> zFluencyWord,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zFluencyWord,) (zacasiPTSD -> zCES,) (zCES -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (Age0-> zFluencyWord,)(Sex-> zFluencyWord,) (Race -> zFluencyWord, ) (PovStat -> zFluencyWord,) (edubrg1-> zFluencyWord,) (edubrg3-> zFluencyWord,) (smokebr -> zFluencyWord,) (currdrugs -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (hei2010_total_score -> zFluencyWord,) (Energy_mean -> zFluencyWord,) (zCES -> zFluencyWord) (WRATtotal-> zFluencyWord,) (SRHg1-> zFluencyWord,) (SRHg3-> zFluencyWord,) (BMI-> zFluencyWord,) (comorbid-> zFluencyWord,)  (allostatic_load-> zFluencyWord,) (IMTmean-> zFluencyWord,) (invmillsfinal -> zFluencyWord,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zFluencyWord,) (zacasiPTSD -> zCES,) (zCES -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (Age0-> zFluencyWord,)(Sex-> zFluencyWord,) (Race -> zFluencyWord, ) (PovStat -> zFluencyWord,) (edubrg1-> zFluencyWord,) (edubrg3-> zFluencyWord,) (smokebr -> zFluencyWord,) (currdrugs -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (hei2010_total_score -> zFluencyWord,) (Energy_mean -> zFluencyWord,) (zCES -> zFluencyWord) (WRATtotal-> zFluencyWord,) (SRHg1-> zFluencyWord,) (SRHg3-> zFluencyWord,) (BMI-> zFluencyWord,) (comorbid-> zFluencyWord,)  (allostatic_load-> zFluencyWord,) (IMTmean-> zFluencyWord,) (invmillsfinal -> zFluencyWord,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zFluencyWord,) (zacasiPTSD -> zCES,) (zCES -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (Age0-> zFluencyWord,)(Sex-> zFluencyWord,) (Race -> zFluencyWord, ) (PovStat -> zFluencyWord,) (edubrg1-> zFluencyWord,) (edubrg3-> zFluencyWord,) (smokebr -> zFluencyWord,) (currdrugs -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (hei2010_total_score -> zFluencyWord,) (Energy_mean -> zFluencyWord,) (zCES -> zFluencyWord) (WRATtotal-> zFluencyWord,) (SRHg1-> zFluencyWord,) (SRHg3-> zFluencyWord,) (BMI-> zFluencyWord,) (comorbid-> zFluencyWord,)  (allostatic_load-> zFluencyWord,) (IMTmean-> zFluencyWord,) (invmillsfinal -> zFluencyWord,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zFluencyWord,) (zacasiPTSD -> zCES,) (zCES -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (Age0-> zFluencyWord,)(Sex-> zFluencyWord,) (Race -> zFluencyWord, ) (PovStat -> zFluencyWord,) (edubrg1-> zFluencyWord,) (edubrg3-> zFluencyWord,) (smokebr -> zFluencyWord,) (currdrugs -> zFluencyWord,) (zacasiPTSD -> zFluencyWord,) (hei2010_total_score -> zFluencyWord,) (Energy_mean -> zFluencyWord,) (zCES -> zFluencyWord) (WRATtotal-> zFluencyWord,) (SRHg1-> zFluencyWord,) (SRHg3-> zFluencyWord,) (BMI-> zFluencyWord,) (comorbid-> zFluencyWord,)  (allostatic_load-> zFluencyWord,) (IMTmean-> zFluencyWord,) (invmillsfinal -> zFluencyWord,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zDigitSpanFwd***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanFwd,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (Age0-> zDigitSpanFwd,)(Sex-> zDigitSpanFwd,) (Race -> zDigitSpanFwd, ) (PovStat -> zDigitSpanFwd,) (edubrg1-> zDigitSpanFwd,) (edubrg3-> zDigitSpanFwd,) (smokebr -> zDigitSpanFwd,) (currdrugs -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (hei2010_total_score -> zDigitSpanFwd,) (Energy_mean -> zDigitSpanFwd,) (zCES -> zDigitSpanFwd) (WRATtotal-> zDigitSpanFwd,) (SRHg1-> zDigitSpanFwd,) (SRHg3-> zDigitSpanFwd,) (BMI-> zDigitSpanFwd,) (comorbid-> zDigitSpanFwd,)  (allostatic_load-> zDigitSpanFwd,) (IMTmean-> zDigitSpanFwd,) (invmillsfinal -> zDigitSpanFwd,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanFwd,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (Age0-> zDigitSpanFwd,)(Sex-> zDigitSpanFwd,) (Race -> zDigitSpanFwd, ) (PovStat -> zDigitSpanFwd,) (edubrg1-> zDigitSpanFwd,) (edubrg3-> zDigitSpanFwd,) (smokebr -> zDigitSpanFwd,) (currdrugs -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (hei2010_total_score -> zDigitSpanFwd,) (Energy_mean -> zDigitSpanFwd,) (zCES -> zDigitSpanFwd) (WRATtotal-> zDigitSpanFwd,) (SRHg1-> zDigitSpanFwd,) (SRHg3-> zDigitSpanFwd,) (BMI-> zDigitSpanFwd,) (comorbid-> zDigitSpanFwd,)  (allostatic_load-> zDigitSpanFwd,) (IMTmean-> zDigitSpanFwd,) (invmillsfinal -> zDigitSpanFwd,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanFwd,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (Age0-> zDigitSpanFwd,)(Sex-> zDigitSpanFwd,) (Race -> zDigitSpanFwd, ) (PovStat -> zDigitSpanFwd,) (edubrg1-> zDigitSpanFwd,) (edubrg3-> zDigitSpanFwd,) (smokebr -> zDigitSpanFwd,) (currdrugs -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (hei2010_total_score -> zDigitSpanFwd,) (Energy_mean -> zDigitSpanFwd,) (zCES -> zDigitSpanFwd) (WRATtotal-> zDigitSpanFwd,) (SRHg1-> zDigitSpanFwd,) (SRHg3-> zDigitSpanFwd,) (BMI-> zDigitSpanFwd,) (comorbid-> zDigitSpanFwd,)  (allostatic_load-> zDigitSpanFwd,) (IMTmean-> zDigitSpanFwd,) (invmillsfinal -> zDigitSpanFwd,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanFwd,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (Age0-> zDigitSpanFwd,)(Sex-> zDigitSpanFwd,) (Race -> zDigitSpanFwd, ) (PovStat -> zDigitSpanFwd,) (edubrg1-> zDigitSpanFwd,) (edubrg3-> zDigitSpanFwd,) (smokebr -> zDigitSpanFwd,) (currdrugs -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (hei2010_total_score -> zDigitSpanFwd,) (Energy_mean -> zDigitSpanFwd,) (zCES -> zDigitSpanFwd) (WRATtotal-> zDigitSpanFwd,) (SRHg1-> zDigitSpanFwd,) (SRHg3-> zDigitSpanFwd,) (BMI-> zDigitSpanFwd,) (comorbid-> zDigitSpanFwd,)  (allostatic_load-> zDigitSpanFwd,) (IMTmean-> zDigitSpanFwd,) (invmillsfinal -> zDigitSpanFwd,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanFwd,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (Age0-> zDigitSpanFwd,)(Sex-> zDigitSpanFwd,) (Race -> zDigitSpanFwd, ) (PovStat -> zDigitSpanFwd,) (edubrg1-> zDigitSpanFwd,) (edubrg3-> zDigitSpanFwd,) (smokebr -> zDigitSpanFwd,) (currdrugs -> zDigitSpanFwd,) (zacasiPTSD -> zDigitSpanFwd,) (hei2010_total_score -> zDigitSpanFwd,) (Energy_mean -> zDigitSpanFwd,) (zCES -> zDigitSpanFwd) (WRATtotal-> zDigitSpanFwd,) (SRHg1-> zDigitSpanFwd,) (SRHg3-> zDigitSpanFwd,) (BMI-> zDigitSpanFwd,) (comorbid-> zDigitSpanFwd,)  (allostatic_load-> zDigitSpanFwd,) (IMTmean-> zDigitSpanFwd,) (invmillsfinal -> zDigitSpanFwd,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zDigitSpanBck***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanBck,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (Age0-> zDigitSpanBck,)(Sex-> zDigitSpanBck,) (Race -> zDigitSpanBck, ) (PovStat -> zDigitSpanBck,) (edubrg1-> zDigitSpanBck,) (edubrg3-> zDigitSpanBck,) (smokebr -> zDigitSpanBck,) (currdrugs -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (hei2010_total_score -> zDigitSpanBck,) (Energy_mean -> zDigitSpanBck,) (zCES -> zDigitSpanBck) (WRATtotal-> zDigitSpanBck,) (SRHg1-> zDigitSpanBck,) (SRHg3->zDigitSpanBck,) (BMI-> zDigitSpanBck,) (comorbid-> zDigitSpanBck,)  (allostatic_load-> zDigitSpanBck,) (IMTmean-> zDigitSpanBck,) (invmillsfinal -> zDigitSpanBck,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanBck,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (Age0-> zDigitSpanBck,)(Sex-> zDigitSpanBck,) (Race -> zDigitSpanBck, ) (PovStat -> zDigitSpanBck,) (edubrg1-> zDigitSpanBck,) (edubrg3-> zDigitSpanBck,) (smokebr -> zDigitSpanBck,) (currdrugs -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (hei2010_total_score -> zDigitSpanBck,) (Energy_mean -> zDigitSpanBck,) (zCES -> zDigitSpanBck) (WRATtotal-> zDigitSpanBck,) (SRHg1-> zDigitSpanBck,) (SRHg3->zDigitSpanBck,) (BMI-> zDigitSpanBck,) (comorbid-> zDigitSpanBck,)  (allostatic_load-> zDigitSpanBck,) (IMTmean-> zDigitSpanBck,) (invmillsfinal -> zDigitSpanBck,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanBck,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (Age0-> zDigitSpanBck,)(Sex-> zDigitSpanBck,) (Race -> zDigitSpanBck, ) (PovStat -> zDigitSpanBck,) (edubrg1-> zDigitSpanBck,) (edubrg3-> zDigitSpanBck,) (smokebr -> zDigitSpanBck,) (currdrugs -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (hei2010_total_score -> zDigitSpanBck,) (Energy_mean -> zDigitSpanBck,) (zCES -> zDigitSpanBck) (WRATtotal-> zDigitSpanBck,) (SRHg1-> zDigitSpanBck,) (SRHg3->zDigitSpanBck,) (BMI-> zDigitSpanBck,) (comorbid-> zDigitSpanBck,)  (allostatic_load-> zDigitSpanBck,) (IMTmean-> zDigitSpanBck,) (invmillsfinal -> zDigitSpanBck,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanBck,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (Age0-> zDigitSpanBck,)(Sex-> zDigitSpanBck,) (Race -> zDigitSpanBck, ) (PovStat -> zDigitSpanBck,) (edubrg1-> zDigitSpanBck,) (edubrg3-> zDigitSpanBck,) (smokebr -> zDigitSpanBck,) (currdrugs -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (hei2010_total_score -> zDigitSpanBck,) (Energy_mean -> zDigitSpanBck,) (zCES -> zDigitSpanBck) (WRATtotal-> zDigitSpanBck,) (SRHg1-> zDigitSpanBck,) (SRHg3->zDigitSpanBck,) (BMI-> zDigitSpanBck,) (comorbid-> zDigitSpanBck,)  (allostatic_load-> zDigitSpanBck,) (IMTmean-> zDigitSpanBck,) (invmillsfinal -> zDigitSpanBck,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zDigitSpanBck,) (zacasiPTSD -> zCES,) (zCES -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (Age0-> zDigitSpanBck,)(Sex-> zDigitSpanBck,) (Race -> zDigitSpanBck, ) (PovStat -> zDigitSpanBck,) (edubrg1-> zDigitSpanBck,) (edubrg3-> zDigitSpanBck,) (smokebr -> zDigitSpanBck,) (currdrugs -> zDigitSpanBck,) (zacasiPTSD -> zDigitSpanBck,) (hei2010_total_score -> zDigitSpanBck,) (Energy_mean -> zDigitSpanBck,) (zCES -> zDigitSpanBck) (WRATtotal-> zDigitSpanBck,) (SRHg1-> zDigitSpanBck,) (SRHg3->zDigitSpanBck,) (BMI-> zDigitSpanBck,) (comorbid-> zDigitSpanBck,)  (allostatic_load-> zDigitSpanBck,) (IMTmean-> zDigitSpanBck,) (invmillsfinal -> zDigitSpanBck,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zclock_command***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zclock_command,) (zacasiPTSD -> zCES,) (zCES -> zclock_command,) (zacasiPTSD -> zclock_command,) (Age0-> zclock_command,)(Sex-> zclock_command,) (Race -> zclock_command, ) (PovStat -> zclock_command,) (edubrg1-> zclock_command,) (edubrg3-> zclock_command,) (smokebr -> zclock_command,) (currdrugs -> zclock_command,) (zacasiPTSD -> zclock_command,) (hei2010_total_score -> zclock_command,) (Energy_mean -> zclock_command,) (zCES -> zclock_command) (WRATtotal-> zclock_command,) (SRHg1-> zclock_command,) (SRHg3-> zclock_command,) (BMI-> zclock_command,) (comorbid-> zclock_command,)  (allostatic_load-> zclock_command,) (IMTmean-> zclock_command,) (invmillsfinal -> zclock_command,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zclock_command,) (zacasiPTSD -> zCES,) (zCES -> zclock_command,) (zacasiPTSD -> zclock_command,) (Age0-> zclock_command,)(Sex-> zclock_command,) (Race -> zclock_command, ) (PovStat -> zclock_command,) (edubrg1-> zclock_command,) (edubrg3-> zclock_command,) (smokebr -> zclock_command,) (currdrugs -> zclock_command,) (zacasiPTSD -> zclock_command,) (hei2010_total_score -> zclock_command,) (Energy_mean -> zclock_command,) (zCES -> zclock_command) (WRATtotal-> zclock_command,) (SRHg1-> zclock_command,) (SRHg3-> zclock_command,) (BMI-> zclock_command,) (comorbid-> zclock_command,)  (allostatic_load-> zclock_command,) (IMTmean-> zclock_command,) (invmillsfinal -> zclock_command,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zclock_command,) (zacasiPTSD -> zCES,) (zCES -> zclock_command,) (zacasiPTSD -> zclock_command,) (Age0-> zclock_command,)(Sex-> zclock_command,) (Race -> zclock_command, ) (PovStat -> zclock_command,) (edubrg1-> zclock_command,) (edubrg3-> zclock_command,) (smokebr -> zclock_command,) (currdrugs -> zclock_command,) (zacasiPTSD -> zclock_command,) (hei2010_total_score -> zclock_command,) (Energy_mean -> zclock_command,) (zCES -> zclock_command) (WRATtotal-> zclock_command,) (SRHg1-> zclock_command,) (SRHg3-> zclock_command,) (BMI-> zclock_command,) (comorbid-> zclock_command,)  (allostatic_load-> zclock_command,) (IMTmean-> zclock_command,) (invmillsfinal -> zclock_command,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zclock_command,) (zacasiPTSD -> zCES,) (zCES -> zclock_command,) (zacasiPTSD -> zclock_command,) (Age0-> zclock_command,)(Sex-> zclock_command,) (Race -> zclock_command, ) (PovStat -> zclock_command,) (edubrg1-> zclock_command,) (edubrg3-> zclock_command,) (smokebr -> zclock_command,) (currdrugs -> zclock_command,) (zacasiPTSD -> zclock_command,) (hei2010_total_score -> zclock_command,) (Energy_mean -> zclock_command,) (zCES -> zclock_command) (WRATtotal-> zclock_command,) (SRHg1-> zclock_command,) (SRHg3-> zclock_command,) (BMI-> zclock_command,) (comorbid-> zclock_command,)  (allostatic_load-> zclock_command,) (IMTmean-> zclock_command,) (invmillsfinal -> zclock_command,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zclock_command,) (zacasiPTSD -> zCES,) (zCES -> zclock_command,) (zacasiPTSD -> zclock_command,) (Age0-> zclock_command,)(Sex-> zclock_command,) (Race -> zclock_command, ) (PovStat -> zclock_command,) (edubrg1-> zclock_command,) (edubrg3-> zclock_command,) (smokebr -> zclock_command,) (currdrugs -> zclock_command,) (zacasiPTSD -> zclock_command,) (hei2010_total_score -> zclock_command,) (Energy_mean -> zclock_command,) (zCES -> zclock_command) (WRATtotal-> zclock_command,) (SRHg1-> zclock_command,) (SRHg3-> zclock_command,) (BMI-> zclock_command,) (comorbid-> zclock_command,)  (allostatic_load-> zclock_command,) (IMTmean-> zclock_command,) (invmillsfinal -> zclock_command,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zLnTrailsAtestSec***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsAtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (Age0-> zLnTrailsAtestSec,)(Sex-> zLnTrailsAtestSec,) (Race -> zLnTrailsAtestSec, ) (PovStat -> zLnTrailsAtestSec,) (edubrg1-> zLnTrailsAtestSec,) (edubrg3-> zLnTrailsAtestSec,) (smokebr -> zLnTrailsAtestSec,) (currdrugs -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (hei2010_total_score -> zLnTrailsAtestSec,) (Energy_mean -> zLnTrailsAtestSec,) (zCES -> zLnTrailsAtestSec) (WRATtotal-> zLnTrailsAtestSec,) (SRHg1-> zLnTrailsAtestSec,) (SRHg3-> zLnTrailsAtestSec,) (BMI-> zLnTrailsAtestSec,) (comorbid-> zLnTrailsAtestSec,)  (allostatic_load-> zLnTrailsAtestSec,)  (IMTmean-> zLnTrailsAtestSec,) (invmillsfinal -> zLnTrailsAtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsAtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (Age0-> zLnTrailsAtestSec,)(Sex-> zLnTrailsAtestSec,) (Race -> zLnTrailsAtestSec, ) (PovStat -> zLnTrailsAtestSec,) (edubrg1-> zLnTrailsAtestSec,) (edubrg3-> zLnTrailsAtestSec,) (smokebr -> zLnTrailsAtestSec,) (currdrugs -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (hei2010_total_score -> zLnTrailsAtestSec,) (Energy_mean -> zLnTrailsAtestSec,) (zCES -> zLnTrailsAtestSec) (WRATtotal-> zLnTrailsAtestSec,) (SRHg1-> zLnTrailsAtestSec,) (SRHg3-> zLnTrailsAtestSec,) (BMI-> zLnTrailsAtestSec,) (comorbid-> zLnTrailsAtestSec,)  (allostatic_load-> zLnTrailsAtestSec,)  (IMTmean-> zLnTrailsAtestSec,) (invmillsfinal -> zLnTrailsAtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsAtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (Age0-> zLnTrailsAtestSec,)(Sex-> zLnTrailsAtestSec,) (Race -> zLnTrailsAtestSec, ) (PovStat -> zLnTrailsAtestSec,) (edubrg1-> zLnTrailsAtestSec,) (edubrg3-> zLnTrailsAtestSec,) (smokebr -> zLnTrailsAtestSec,) (currdrugs -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (hei2010_total_score -> zLnTrailsAtestSec,) (Energy_mean -> zLnTrailsAtestSec,) (zCES -> zLnTrailsAtestSec) (WRATtotal-> zLnTrailsAtestSec,) (SRHg1-> zLnTrailsAtestSec,) (SRHg3-> zLnTrailsAtestSec,) (BMI-> zLnTrailsAtestSec,) (comorbid-> zLnTrailsAtestSec,)  (allostatic_load-> zLnTrailsAtestSec,)  (IMTmean-> zLnTrailsAtestSec,) (invmillsfinal -> zLnTrailsAtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsAtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (Age0-> zLnTrailsAtestSec,)(Sex-> zLnTrailsAtestSec,) (Race -> zLnTrailsAtestSec, ) (PovStat -> zLnTrailsAtestSec,) (edubrg1-> zLnTrailsAtestSec,) (edubrg3-> zLnTrailsAtestSec,) (smokebr -> zLnTrailsAtestSec,) (currdrugs -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (hei2010_total_score -> zLnTrailsAtestSec,) (Energy_mean -> zLnTrailsAtestSec,) (zCES -> zLnTrailsAtestSec) (WRATtotal-> zLnTrailsAtestSec,) (SRHg1-> zLnTrailsAtestSec,) (SRHg3-> zLnTrailsAtestSec,) (BMI-> zLnTrailsAtestSec,) (comorbid-> zLnTrailsAtestSec,)  (allostatic_load-> zLnTrailsAtestSec,)  (IMTmean-> zLnTrailsAtestSec,) (invmillsfinal -> zLnTrailsAtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsAtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (Age0-> zLnTrailsAtestSec,)(Sex-> zLnTrailsAtestSec,) (Race -> zLnTrailsAtestSec, ) (PovStat -> zLnTrailsAtestSec,) (edubrg1-> zLnTrailsAtestSec,) (edubrg3-> zLnTrailsAtestSec,) (smokebr -> zLnTrailsAtestSec,) (currdrugs -> zLnTrailsAtestSec,) (zacasiPTSD -> zLnTrailsAtestSec,) (hei2010_total_score -> zLnTrailsAtestSec,) (Energy_mean -> zLnTrailsAtestSec,) (zCES -> zLnTrailsAtestSec) (WRATtotal-> zLnTrailsAtestSec,) (SRHg1-> zLnTrailsAtestSec,) (SRHg3-> zLnTrailsAtestSec,) (BMI-> zLnTrailsAtestSec,) (comorbid-> zLnTrailsAtestSec,)  (allostatic_load-> zLnTrailsAtestSec,) (IMTmean-> zLnTrailsAtestSec,) (invmillsfinal -> zLnTrailsAtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zLnTrailsBtestSec***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsBtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (Age0-> zLnTrailsBtestSec,)(Sex-> zLnTrailsBtestSec,) (Race -> zLnTrailsBtestSec, ) (PovStat -> zLnTrailsBtestSec,) (edubrg1-> zLnTrailsBtestSec,) (edubrg3-> zLnTrailsBtestSec,) (smokebr -> zLnTrailsBtestSec,) (currdrugs -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (hei2010_total_score -> zLnTrailsBtestSec,) (Energy_mean -> zLnTrailsBtestSec,) (zCES -> zLnTrailsBtestSec) (WRATtotal-> zLnTrailsBtestSec,) (SRHg1-> zLnTrailsBtestSec,) (SRHg3-> zLnTrailsBtestSec,) (BMI-> zLnTrailsBtestSec,) (comorbid-> zLnTrailsBtestSec,)  (allostatic_load-> zLnTrailsBtestSec,)  (IMTmean-> zLnTrailsBtestSec,) (invmillsfinal -> zLnTrailsBtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsBtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (Age0-> zLnTrailsBtestSec,)(Sex-> zLnTrailsBtestSec,) (Race -> zLnTrailsBtestSec, ) (PovStat -> zLnTrailsBtestSec,) (edubrg1-> zLnTrailsBtestSec,) (edubrg3-> zLnTrailsBtestSec,) (smokebr -> zLnTrailsBtestSec,) (currdrugs -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (hei2010_total_score -> zLnTrailsBtestSec,) (Energy_mean -> zLnTrailsBtestSec,) (zCES -> zLnTrailsBtestSec) (WRATtotal-> zLnTrailsBtestSec,) (SRHg1-> zLnTrailsBtestSec,) (SRHg3-> zLnTrailsBtestSec,) (BMI-> zLnTrailsBtestSec,) (comorbid-> zLnTrailsBtestSec,)  (allostatic_load-> zLnTrailsBtestSec,)  (IMTmean-> zLnTrailsBtestSec,) (invmillsfinal -> zLnTrailsBtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsBtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (Age0-> zLnTrailsBtestSec,)(Sex-> zLnTrailsBtestSec,) (Race -> zLnTrailsBtestSec, ) (PovStat -> zLnTrailsBtestSec,) (edubrg1-> zLnTrailsBtestSec,) (edubrg3-> zLnTrailsBtestSec,) (smokebr -> zLnTrailsBtestSec,) (currdrugs -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (hei2010_total_score -> zLnTrailsBtestSec,) (Energy_mean -> zLnTrailsBtestSec,) (zCES -> zLnTrailsBtestSec) (WRATtotal-> zLnTrailsBtestSec,) (SRHg1-> zLnTrailsBtestSec,) (SRHg3-> zLnTrailsBtestSec,) (BMI-> zLnTrailsBtestSec,) (comorbid-> zLnTrailsBtestSec,)  (allostatic_load-> zLnTrailsBtestSec,)  (IMTmean-> zLnTrailsBtestSec,) (invmillsfinal -> zLnTrailsBtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsBtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (Age0-> zLnTrailsBtestSec,)(Sex-> zLnTrailsBtestSec,) (Race -> zLnTrailsBtestSec, ) (PovStat -> zLnTrailsBtestSec,) (edubrg1-> zLnTrailsBtestSec,) (edubrg3-> zLnTrailsBtestSec,) (smokebr -> zLnTrailsBtestSec,) (currdrugs -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (hei2010_total_score -> zLnTrailsBtestSec,) (Energy_mean -> zLnTrailsBtestSec,) (zCES -> zLnTrailsBtestSec) (WRATtotal-> zLnTrailsBtestSec,) (SRHg1-> zLnTrailsBtestSec,) (SRHg3-> zLnTrailsBtestSec,) (BMI-> zLnTrailsBtestSec,) (comorbid-> zLnTrailsBtestSec,)  (allostatic_load-> zLnTrailsBtestSec,)  (IMTmean-> zLnTrailsBtestSec,) (invmillsfinal -> zLnTrailsBtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zLnTrailsBtestSec,) (zacasiPTSD -> zCES,) (zCES -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (Age0-> zLnTrailsBtestSec,)(Sex-> zLnTrailsBtestSec,) (Race -> zLnTrailsBtestSec, ) (PovStat -> zLnTrailsBtestSec,) (edubrg1-> zLnTrailsBtestSec,) (edubrg3-> zLnTrailsBtestSec,) (smokebr -> zLnTrailsBtestSec,) (currdrugs -> zLnTrailsBtestSec,) (zacasiPTSD -> zLnTrailsBtestSec,) (hei2010_total_score -> zLnTrailsBtestSec,) (Energy_mean -> zLnTrailsBtestSec,) (zCES -> zLnTrailsBtestSec) (WRATtotal-> zLnTrailsBtestSec,) (SRHg1-> zLnTrailsBtestSec,) (SRHg3-> zLnTrailsBtestSec,) (BMI-> zLnTrailsBtestSec,) (comorbid-> zLnTrailsBtestSec,)  (allostatic_load-> zLnTrailsBtestSec,) (IMTmean-> zLnTrailsBtestSec,) (invmillsfinal -> zLnTrailsBtestSec,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for identpic***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> identpic,) (zacasiPTSD -> zCES,) (zCES -> identpic,) (zacasiPTSD -> identpic,) (Age0-> identpic,)(Sex-> identpic,) (Race -> identpic, ) (PovStat -> identpic,) (edubrg1-> identpic,) (edubrg3-> identpic,) (smokebr -> identpic,) (currdrugs -> identpic,) (zacasiPTSD -> identpic,) (hei2010_total_score -> identpic,) (Energy_mean -> identpic,) (zCES -> identpic) (WRATtotal-> identpic,) (SRHg1-> identpic,) (SRHg3-> identpic,) (BMI-> identpic,) (comorbid-> identpic,)  (allostatic_load-> identpic,)  (IMTmean-> identpic,) (invmillsfinal -> identpic,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> identpic,) (zacasiPTSD -> zCES,) (zCES -> identpic,) (zacasiPTSD -> identpic,) (Age0-> identpic,)(Sex-> identpic,) (Race -> identpic, ) (PovStat -> identpic,) (edubrg1-> identpic,) (edubrg3-> identpic,) (smokebr -> identpic,) (currdrugs -> identpic,) (zacasiPTSD -> identpic,) (hei2010_total_score -> identpic,) (Energy_mean -> identpic,) (zCES -> identpic) (WRATtotal-> identpic,) (SRHg1-> identpic,) (SRHg3-> identpic,) (BMI-> identpic,) (comorbid-> identpic,)  (allostatic_load-> identpic,)  (IMTmean-> identpic,) (invmillsfinal -> identpic,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> identpic,) (zacasiPTSD -> zCES,) (zCES -> identpic,) (zacasiPTSD -> identpic,) (Age0-> identpic,)(Sex-> identpic,) (Race -> identpic, ) (PovStat -> identpic,) (edubrg1-> identpic,) (edubrg3-> identpic,) (smokebr -> identpic,) (currdrugs -> identpic,) (zacasiPTSD -> identpic,) (hei2010_total_score -> identpic,) (Energy_mean -> identpic,) (zCES -> identpic) (WRATtotal-> identpic,) (SRHg1-> identpic,) (SRHg3-> identpic,) (BMI-> identpic,) (comorbid-> identpic,)  (allostatic_load-> identpic,)  (IMTmean-> identpic,) (invmillsfinal -> identpic,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> identpic,) (zacasiPTSD -> zCES,) (zCES -> identpic,) (zacasiPTSD -> identpic,) (Age0-> identpic,)(Sex-> identpic,) (Race -> identpic, ) (PovStat -> identpic,) (edubrg1-> identpic,) (edubrg3-> identpic,) (smokebr -> identpic,) (currdrugs -> identpic,) (zacasiPTSD -> identpic,) (hei2010_total_score -> identpic,) (Energy_mean -> identpic,) (zCES -> identpic) (WRATtotal-> identpic,) (SRHg1-> identpic,) (SRHg3-> identpic,) (BMI-> identpic,) (comorbid-> identpic,)  (allostatic_load-> identpic,)  (IMTmean-> identpic,) (invmillsfinal -> identpic,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> identpic,) (zacasiPTSD -> zCES,) (zCES -> identpic,) (zacasiPTSD -> identpic,) (Age0-> identpic,)(Sex-> identpic,) (Race -> identpic, ) (PovStat -> identpic,) (edubrg1-> identpic,) (edubrg3-> identpic,) (smokebr -> identpic,) (currdrugs -> identpic,) (zacasiPTSD -> identpic,) (hei2010_total_score -> identpic,) (Energy_mean -> identpic,) (zCES -> identpic) (WRATtotal-> identpic,) (SRHg1-> identpic,) (SRHg3-> identpic,) (BMI-> identpic,) (comorbid-> identpic,)  (allostatic_load-> identpic,) (IMTmean-> identpic,) (invmillsfinal -> identpic,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zCrdRot***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCrdRot,) (zacasiPTSD -> zCES,) (zCES -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (Age0-> zCrdRot,)(Sex-> zCrdRot,) (Race -> zCrdRot, ) (PovStat -> zCrdRot,) (edubrg1-> zCrdRot,) (edubrg3-> zCrdRot,) (smokebr -> zCrdRot,) (currdrugs -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (hei2010_total_score -> zCrdRot,) (Energy_mean -> zCrdRot,) (zCES -> zCrdRot) (WRATtotal-> zCrdRot,) (SRHg1-> zCrdRot,) (SRHg3-> zCrdRot,) (BMI-> zCrdRot,) (comorbid-> zCrdRot,)  (allostatic_load-> zCrdRot,)  (IMTmean-> zCrdRot,) (invmillsfinal -> zCrdRot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCrdRot,) (zacasiPTSD -> zCES,) (zCES -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (Age0-> zCrdRot,)(Sex-> zCrdRot,) (Race -> zCrdRot, ) (PovStat -> zCrdRot,) (edubrg1-> zCrdRot,) (edubrg3-> zCrdRot,) (smokebr -> zCrdRot,) (currdrugs -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (hei2010_total_score -> zCrdRot,) (Energy_mean -> zCrdRot,) (zCES -> zCrdRot) (WRATtotal-> zCrdRot,) (SRHg1-> zCrdRot,) (SRHg3-> zCrdRot,) (BMI-> zCrdRot,) (comorbid-> zCrdRot,)  (allostatic_load-> zCrdRot,)  (IMTmean-> zCrdRot,) (invmillsfinal -> zCrdRot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCrdRot,) (zacasiPTSD -> zCES,) (zCES -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (Age0-> zCrdRot,)(Sex-> zCrdRot,) (Race -> zCrdRot, ) (PovStat -> zCrdRot,) (edubrg1-> zCrdRot,) (edubrg3-> zCrdRot,) (smokebr -> zCrdRot,) (currdrugs -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (hei2010_total_score -> zCrdRot,) (Energy_mean -> zCrdRot,) (zCES -> zCrdRot) (WRATtotal-> zCrdRot,) (SRHg1-> zCrdRot,) (SRHg3-> zCrdRot,) (BMI-> zCrdRot,) (comorbid-> zCrdRot,)  (allostatic_load-> zCrdRot,)  (IMTmean-> zCrdRot,) (invmillsfinal -> zCrdRot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCrdRot,) (zacasiPTSD -> zCES,) (zCES -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (Age0-> zCrdRot,)(Sex-> zCrdRot,) (Race -> zCrdRot, ) (PovStat -> zCrdRot,) (edubrg1-> zCrdRot,) (edubrg3-> zCrdRot,) (smokebr -> zCrdRot,) (currdrugs -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (hei2010_total_score -> zCrdRot,) (Energy_mean -> zCrdRot,) (zCES -> zCrdRot) (WRATtotal-> zCrdRot,) (SRHg1-> zCrdRot,) (SRHg3-> zCrdRot,) (BMI-> zCrdRot,) (comorbid-> zCrdRot,)  (allostatic_load-> zCrdRot,)  (IMTmean-> zCrdRot,) (invmillsfinal -> zCrdRot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zCrdRot,) (zacasiPTSD -> zCES,) (zCES -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (Age0-> zCrdRot,)(Sex-> zCrdRot,) (Race -> zCrdRot, ) (PovStat -> zCrdRot,) (edubrg1-> zCrdRot,) (edubrg3-> zCrdRot,) (smokebr -> zCrdRot,) (currdrugs -> zCrdRot,) (zacasiPTSD -> zCrdRot,) (hei2010_total_score -> zCrdRot,) (Energy_mean -> zCrdRot,) (zCES -> zCrdRot) (WRATtotal-> zCrdRot,) (SRHg1-> zCrdRot,) (SRHg3-> zCrdRot,) (BMI-> zCrdRot,) (comorbid-> zCrdRot,)  (allostatic_load-> zCrdRot,) (IMTmean-> zCrdRot,) (invmillsfinal -> zCrdRot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

***mi xeq for zidentpictot***
mi xeq 1: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zidentpictot,) (zacasiPTSD -> zCES,) (zCES -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (Age0-> zidentpictot,)(Sex->zidentpictot,) (Race -> zidentpictot, ) (PovStat -> zidentpictot,) (edubrg1-> zidentpictot,) (edubrg3-> zidentpictot,) (smokebr -> zidentpictot,) (currdrugs -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (hei2010_total_score -> zidentpictot,) (Energy_mean -> zidentpictot,) (zCES -> zidentpictot,) (WRATtotal-> zidentpictot,) (SRHg1-> zidentpictot,) (SRHg3-> zidentpictot,) (BMI-> zidentpictot,) (comorbid-> zidentpictot,)  (allostatic_load-> zidentpictot,)  (IMTmean-> zidentpictot,) (invmillsfinal -> zidentpictot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 2: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zidentpictot,) (zacasiPTSD -> zCES,) (zCES -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (Age0-> zidentpictot,)(Sex->zidentpictot,) (Race -> zidentpictot, ) (PovStat -> zidentpictot,) (edubrg1-> zidentpictot,) (edubrg3-> zidentpictot,) (smokebr -> zidentpictot,) (currdrugs -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (hei2010_total_score -> zidentpictot,) (Energy_mean -> zidentpictot,) (zCES -> zidentpictot,) (WRATtotal-> zidentpictot,) (SRHg1-> zidentpictot,) (SRHg3-> zidentpictot,) (BMI-> zidentpictot,) (comorbid-> zidentpictot,)  (allostatic_load-> zidentpictot,)  (IMTmean-> zidentpictot,) (invmillsfinal -> zidentpictot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

mi xeq 3: sem (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zidentpictot,) (zacasiPTSD -> zCES,) (zCES -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (Age0-> zidentpictot,)(Sex->zidentpictot,) (Race -> zidentpictot, ) (PovStat -> zidentpictot,) (edubrg1-> zidentpictot,) (edubrg3-> zidentpictot,) (smokebr -> zidentpictot,) (currdrugs -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (hei2010_total_score -> zidentpictot,) (Energy_mean -> zidentpictot,) (zCES -> zidentpictot,) (WRATtotal-> zidentpictot,) (SRHg1-> zidentpictot,) (SRHg3-> zidentpictot,) (BMI-> zidentpictot,) (comorbid-> zidentpictot,)  (allostatic_load-> zidentpictot,)  (IMTmean-> zidentpictot,) (invmillsfinal -> zidentpictot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects


mi xeq 4: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zidentpictot,) (zacasiPTSD -> zCES,) (zCES -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (Age0-> zidentpictot,)(Sex->zidentpictot,) (Race -> zidentpictot, ) (PovStat -> zidentpictot,) (edubrg1-> zidentpictot,) (edubrg3-> zidentpictot,) (smokebr -> zidentpictot,) (currdrugs -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (hei2010_total_score -> zidentpictot,) (Energy_mean -> zidentpictot,) (zCES -> zidentpictot,) (WRATtotal-> zidentpictot,) (SRHg1-> zidentpictot,) (SRHg3-> zidentpictot,) (BMI-> zidentpictot,) (comorbid-> zidentpictot,)  (allostatic_load-> zidentpictot,)  (IMTmean-> zidentpictot,) (invmillsfinal -> zidentpictot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects


mi xeq 5: sem  (Age0-> zacasiPTSD,) (Sex-> zacasiPTSD,) (Race-> zacasiPTSD,) (PovStat-> zacasiPTSD,) (edubrg1-> zacasiPTSD,) (edubrg3-> zacasiPTSD,) (smokebr-> zacasiPTSD,) (currdrugs-> zacasiPTSD,) (hei2010_total_score-> zacasiPTSD,) (Energy_mean-> zacasiPTSD,)   (WRATtotal-> zacasiPTSD,) (SRHg1-> zacasiPTSD,) (SRHg3-> zacasiPTSD,) (BMI-> zacasiPTSD,) (comorbid-> zacasiPTSD,) (allostatic_load-> zacasiPTSD,) (IMTmean-> zacasiPTSD,)(invmillsfinal-> zacasiPTSD,) (zacasiPTSD -> zidentpictot,) (zacasiPTSD -> zCES,) (zCES -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (Age0-> zidentpictot,)(Sex->zidentpictot,) (Race -> zidentpictot, ) (PovStat -> zidentpictot,) (edubrg1-> zidentpictot,) (edubrg3-> zidentpictot,) (smokebr -> zidentpictot,) (currdrugs -> zidentpictot,) (zacasiPTSD -> zidentpictot,) (hei2010_total_score -> zidentpictot,) (Energy_mean -> zidentpictot,) (zCES -> zidentpictot,) (WRATtotal-> zidentpictot,) (SRHg1-> zidentpictot,) (SRHg3-> zidentpictot,) (BMI-> zidentpictot,) (comorbid-> zidentpictot,)  (allostatic_load-> zidentpictot,)  (IMTmean-> zidentpictot,) (invmillsfinal -> zidentpictot,) (Age0-> zCES,) (Sex -> zCES,) (Race -> zCES,) (PovStat -> zCES,) (edubrg1-> zCES,) (edubrg3-> zCES,) (smokebr -> zCES, ) (currdrugs -> zCES,) (hei2010_total_score -> zCES,) (Energy_mean -> zCES,)  (WRATtotal-> zCES,) (SRHg1-> zCES,) (SRHg3-> zCES,) (BMI-> zCES,) (comorbid-> zCES,)  (allostatic_load-> zCES,) (IMTmean-> zCES,) (invmillsfinal -> zCES,) if sample_final==1 , nocapslatent method(ml)

estat gof, stats(all)
estat teffects

capture log close


cd "E:\HANDLS_PAPER67_PTSD_COGN\DATA"

capture log close
capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\HEATMAP_PTSD.smcl"


//STEP 26A: HEATMAP// 

use HEATMAP_DATA, clear

**COLLAPSE MEAN ESTIMATES AND VARIANCES**
collapse (mean)  de_zptsd_est ie_zptsd_est te_zptsd_est percent_mediated_zptsd var_de_zptsd var_ie_zptsd var_te_zptsd sd_roi te_ptsd_st ie_ptsd_st de_ptsd_st, by(id)

save HEATMAP_DATA_collapsed, replace


**GET ROI LABELS AND MERGE THEM WITH COLLAPSED FILE**

use HEATMAP_DATA, clear
keep if imputation==1
keep id roi
save ROI_LABELS_ID, replace
sort id
save, replace

use HEATMAP_DATA_collapsed
sort id
save, replace

use  ROI_LABELS_ID,clear
merge id using HEATMAP_DATA_collapsed
save HEATMAP_DATA_collapsedfin, replace

****GENERATE STANDARD ERRORS FROM VARIANCES****
su var_de_zptsd var_ie_zptsd var_te_zptsd

foreach x of varlist var_de_zptsd var_ie_zptsd var_te_zptsd {
	gen se`x'=sqrt(`x')
}

capture rename sevar* se*

save, replace

****GENERATE Z-SCORE*****
**z_de_zptsd z_ie_zptsd z_te_zptsd se_de_zptsd se_ie_zptsd se_te_zptsd

gen z_de_ptsd =.
gen z_ie_ptsd =.
gen z_te_ptsd =.

replace z_de_ptsd=de_zptsd_est/se_de_zptsd
replace z_ie_ptsd=ie_zptsd_est/se_ie_zptsd
replace z_te_ptsd=te_zptsd_est/se_te_zptsd

************GENERATE P-VALUES*******************

gen p_de_ptsd =.
gen p_ie_ptsd =.
gen p_te_ptsd =.

replace p_de_ptsd=2*normal(-abs(z_de_ptsd))
replace p_ie_ptsd=2*normal(-abs(z_ie_ptsd))
replace p_te_ptsd=2*normal(-abs(z_te_ptsd))

save, replace




***************************HEATMAP*******************************

tab1 roi te_ptsd_st p_te_ptsd ie_ptsd_st p_ie_ptsd de_ptsd_st p_de_ptsd percent_mediated_zptsd

sort id


list roi te_ptsd_st p_te_ptsd ie_ptsd_st p_ie_ptsd de_ptsd_st p_de_ptsd percent_mediated_zptsd

capture log close

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE3_HEATMAP.smcl"

use HEATMAP_DATA_collapsedfin,clear

list roi sd_roi de_zptsd_est ie_zptsd_est te_zptsd_est se_de_zptsd se_ie_zptsd se_te_zptsd p_de_ptsd p_ie_ptsd p_te_ptsd percent_mediated_zptsd

     
save, replace

//STEP 26B: GENERATE OTHER HEATMAPS// 
cd "E:\HANDLS_PAPER67_PTSD_COGN\HEATMAP_DATA"

**HEATMAP_DATA_1**
use HEATMAP_DATA_1, clear

**COLLAPSE MEAN ESTIMATES AND VARIANCES FOR HETMAP 1**
collapse (mean) G1_PTSDCESD_EST G2_PTSDCESD_EST G3_PTSDCESD_EST g1_ptsdcesd_se g2_ptsdcesd_se g3_ptsdcesd_se, by(id)

save HEATMAP_DATA_1_collapsed, replace


**GET ROI LABELS AND MERGE THEM WITH COLLAPSED FILE**

use HEATMAP_DATA_1, clear
keep if imputation==1
keep id roi
save ROI_LABELS_ID_1, replace
sort id
save, replace

use HEATMAP_DATA_1_collapsed
sort id
save, replace

use  ROI_LABELS_ID_1,clear
merge id using HEATMAP_DATA_1_collapsed
save HEATMAP_DATA_1_collapsedfin, replace

****GENERATE Z-SCORE*****

gen zG1_PTSDCESD_EST =.
gen zG2_PTSDCESD_EST =.
gen zG3_PTSDCESD_EST =.

replace zG1_PTSDCESD_EST=G1_PTSDCESD_EST/g1_ptsdcesd_se
replace zG2_PTSDCESD_EST=G2_PTSDCESD_EST/g2_ptsdcesd_se
replace zG3_PTSDCESD_EST=G3_PTSDCESD_EST/g3_ptsdcesd_se

************GENERATE P-VALUES*******************

gen p_G1_PTSDCESD_EST =.
gen p_G2_PTSDCESD_EST =.
gen p_G3_PTSDCESD_EST =.

replace p_G1_PTSDCESD_EST=2*normal(-abs(zG1_PTSDCESD_EST))
replace p_G2_PTSDCESD_EST=2*normal(-abs(zG2_PTSDCESD_EST))
replace p_G3_PTSDCESD_EST=2*normal(-abs(zG3_PTSDCESD_EST))

save, replace


capture log close


***************************HEATMAP*******************************

tab1 roi G1_PTSDCESD_EST p_G1_PTSDCESD_EST G2_PTSDCESD_EST p_G2_PTSDCESD_EST G3_PTSDCESD_EST p_G3_PTSDCESD_EST

sort id

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\HEATMAP_DATA_1.smcl"

list roi G1_PTSDCESD_EST p_G1_PTSDCESD_EST G2_PTSDCESD_EST p_G2_PTSDCESD_EST G3_PTSDCESD_EST p_G3_PTSDCESD_EST

capture log close

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE3_HEATMAP.smcl"

use HEATMAP_DATA_1_collapsedfin,clear

list roi zG1_PTSDCESD_EST zG2_PTSDCESD_EST zG3_PTSDCESD_EST g1_ptsdcesd_se g2_ptsdcesd_se g3_ptsdcesd_se p_G1_PTSDCESD_EST p_G2_PTSDCESD_EST p_G3_PTSDCESD_EST
     
save, replace

**HEATMAP_DATA_2**
use HEATMAP_DATA_2, clear

**COLLAPSE MEAN ESTIMATES AND VARIANCES FOR HETMAP 1**
collapse (mean) g1_ptsdcogn_est g2_ptsdcogn_est g3_ptsdcogn_est g1_ptsdcogn_se g2_ptsdcogn_se g3_ptsdcogn_se, by(id)

save HEATMAP_DATA_2_collapsed, replace

**GET ROI LABELS AND MERGE THEM WITH COLLAPSED FILE**

use HEATMAP_DATA_2, clear
keep if imputation==1
keep id roi
save ROI_LABELS_ID_2, replace
sort id
save, replace

use HEATMAP_DATA_2_collapsed
sort id
save, replace

use  ROI_LABELS_ID_2,clear
merge id using HEATMAP_DATA_2_collapsed
save HEATMAP_DATA_2_collapsedfin, replace

****GENERATE Z-SCORE*****

gen zg1_ptsdcogn_est =.
gen zg2_ptsdcogn_est =.
gen zg3_ptsdcogn_est =.

replace zg1_ptsdcogn_est=g1_ptsdcogn_est/g1_ptsdcogn_se 
replace zg2_ptsdcogn_est=g2_ptsdcogn_est/g2_ptsdcogn_se
replace zg3_ptsdcogn_est=g3_ptsdcogn_est/g3_ptsdcogn_se

************GENERATE P-VALUES*******************

gen p_g1_ptsdcogn_est =.
gen p_g2_ptsdcogn_est =.
gen p_g3_ptsdcogn_est =.

replace p_g1_ptsdcogn_est=2*normal(-abs(zg1_ptsdcogn_est))
replace p_g2_ptsdcogn_est=2*normal(-abs(zg2_ptsdcogn_est))
replace p_g3_ptsdcogn_est=2*normal(-abs(zg3_ptsdcogn_est))

save, replace


capture log close

***************************HEATMAP*******************************

tab1 roi g1_ptsdcogn_est p_g1_ptsdcogn_est g2_ptsdcogn_est p_g2_ptsdcogn_est g3_ptsdcogn_est p_g3_ptsdcogn_est

sort id

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\HEATMAP_DATA_2.smcl"

list roi g1_ptsdcogn_est p_g1_ptsdcogn_est g2_ptsdcogn_est p_g2_ptsdcogn_est g3_ptsdcogn_est p_g3_ptsdcogn_est

capture log close

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE3_HEATMAP.smcl"

use HEATMAP_DATA_2_collapsedfin,clear

list roi zg1_ptsdcogn_est zg2_ptsdcogn_est zg3_ptsdcogn_est g1_ptsdcogn_se g2_ptsdcogn_se g3_ptsdcogn_se p_g1_ptsdcogn_est p_g2_ptsdcogn_est p_g3_ptsdcogn_est
     
save, replace

**HEATMAP_DATA_3**
use HEATMAP_DATA_3, clear

**COLLAPSE MEAN ESTIMATES AND VARIANCES FOR HETMAP 1**
collapse (mean) g1_cesdcogn_est g2_cesdcogn_est g3_cesdcogn_est g1_cesdcogn_se g2_cesdcogn_se g3_cesdcogn_se, by(id)

save HEATMAP_DATA_3_collapsed, replace

**GET ROI LABELS AND MERGE THEM WITH COLLAPSED FILE**

use HEATMAP_DATA_3, clear
keep if imputation==1
keep id roi
save ROI_LABELS_ID_3, replace
sort id
save, replace

use HEATMAP_DATA_3_collapsed
sort id
save, replace

use  ROI_LABELS_ID_3,clear
merge id using HEATMAP_DATA_3_collapsed
save HEATMAP_DATA_3_collapsedfin, replace

****GENERATE Z-SCORE*****

gen zg1_cesdcogn_est =.
gen zg2_cesdcogn_est =.
gen zg3_cesdcogn_est =.

replace zg1_cesdcogn_est=g1_cesdcogn_est/g1_cesdcogn_se
replace zg2_cesdcogn_est=g2_cesdcogn_est/g2_cesdcogn_se
replace zg3_cesdcogn_est=g3_cesdcogn_est/g3_cesdcogn_se

************GENERATE P-VALUES*******************

gen p_g1_cesdcogn_est =.
gen p_g2_cesdcogn_est =.
gen p_g3_cesdcogn_est =.

replace p_g1_cesdcogn_est=2*normal(-abs(zg1_cesdcogn_est))
replace p_g2_cesdcogn_est=2*normal(-abs(zg2_cesdcogn_est))
replace p_g3_cesdcogn_est=2*normal(-abs(zg3_cesdcogn_est))

save, replace


capture log close

***************************HEATMAP*******************************

tab1 roi g1_cesdcogn_est p_g1_cesdcogn_est g2_cesdcogn_est p_g2_cesdcogn_est g3_cesdcogn_est p_g3_cesdcogn_est

sort id

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\HEATMAP_DATA_2.smcl"

list roi g1_cesdcogn_est p_g1_cesdcogn_est g2_cesdcogn_est p_g2_cesdcogn_est g3_cesdcogn_est p_g3_cesdcogn_est

capture log close

capture log using "E:\HANDLS_PAPER67_PTSD_COGN\OUTPUT\TABLE3_HEATMAP.smcl"

use HEATMAP_DATA_3_collapsedfin,clear

list roi zg1_cesdcogn_est zg2_cesdcogn_est zg3_cesdcogn_est  g1_cesdcogn_se g2_cesdcogn_se g3_cesdcogn_se p_g1_cesdcogn_est p_g2_cesdcogn_est p_g3_cesdcogn_est
     
save, replace

capture log close



