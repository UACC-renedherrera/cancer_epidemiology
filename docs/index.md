# Sources


## United States Cancer Statistics (USCS)


National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics 2001–2016 Public Use Research Database, November 2018 submission (2001–2016), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2019, based on the November 2018 submission. Accessed at www.cdc.gov/cancer/uscs/public-use.


### Raw Data


https://www.cdc.gov/cancer/uscs/USCS-1999-2018-ASCII.zip


## NCHS via SEER


Surveillance, Epidemiology, and End Results (SEER) Program (www.seer.cancer.gov) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1969-2019) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2019 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released April 2021.  Underlying mortality data provided by NCHS (www.cdc.gov/nchs).


### Query


```
{Age at Death.Age recode with <1 year olds} = '00 years','01-04 years','05-09 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years','Unknown'
{Race, Sex, Year Dth, State, Cnty, Reg.Race recode (White, Black, Other)} = 'All races','  White','  Black','  Other (American Indian/AK Native, Asian/Pacific Islander)'
AND {Race, Sex, Year Dth, State, Cnty, Reg.Sex} = 'Male and female','  Male','  Female'
AND {Race, Sex, Year Dth, State, Cnty, Reg.Year of death recode} = '2015-2019'
AND {Race, Sex, Year Dth, State, Cnty, Reg.State} = 'Arizona'
AND {Race, Sex, Year Dth, State, Cnty, Reg.State-county} = '  AZ: Cochise County (04003)','  AZ: Pima County (04019)','  AZ: Pinal County (04021)','  AZ: Santa Cruz County (04023)','    AZ: Yuma County (04027) - 1994+'
{Site and Morphology.Cause of death recode} = '      Lip','      Tongue','      Salivary Gland','      Floor of Mouth','      Gum and Other Mouth','      Nasopharynx','      Tonsil','      Oropharynx','      Hypopharynx','      Other Oral Cavity and Pharynx','      Esophagus','      Stomach','      Small Intestine','      Colon and Rectum','      Anus, Anal Canal and Anorectum','      Liver and Intrahepatic Bile Duct','      Gallbladder','      Other Biliary','      Pancreas','      Retroperitoneum','      Peritoneum, Omentum and Mesentery','      Other Digestive Organs','      Nose, Nasal Cavity and Middle Ear','      Larynx','      Lung and Bronchus','      Pleura','      Trachea, Mediastinum and Other Respiratory Organs','      Melanoma of the Skin','      Non-Melanoma Skin','      Cervix Uteri','      Corpus and Uterus, NOS','      Ovary','      Vagina','      Vulva','      Other Female Genital Organs','      Prostate','      Testis','      Penis','      Other Male Genital Organs','      Urinary Bladder','      Kidney and Renal Pelvis','      Ureter','      Other Urinary Organs','      Thyroid','      Other Endocrine including Thymus','      Hodgkin Lymphoma','      Non-Hodgkin Lymphoma','      Lymphocytic Leukemia','      Myeloid and Monocytic Leukemia','      Other Leukemia'
```


## AZ Cancer Registry


The Arizona Department of Health Services (ADHS) Indicator Based Information System for Public Health (IBIS-PH) system allows the public to query cancer rates, mortality rates and population estimates for Arizona. These public health data sets are intended to support evidenced-based decision making in Arizona to plan and improve service delivery, evaluate health care systems, and inform policy decisions. Other uses are not permissible. Available at http://healthdata.az.gov/query/module_selection/azcr/AzCRSelection.html


```
Query Definition
Query Item	Description / Value
Navigation Path	IBIS-PH > Custom Query > AzCR > Age-Adjusted Cancer Incidence Rates
Module	Arizona Cancer Registry Query Module
Measure	Age-Adjusted Cancer Incidence Rates, Incidence Per 100,000 Population (03/23/2021)
Time of Query	Tue, Sep 21, 2021 1:45 PM, MST
Year Filter	2018, 2017, 2016, 2015, 2014
Cancer Sites Filter	Cancer Sites, Oral Cavity, Esophagus, Stomach, Small Intestine, Colorectal, Anus, Anal Canal and Anorectum, Liver and Intrahepatic Bile Duct, Gallbladder and Other Biliary, Pancreas, Larynx, Lung and Bronchus, Bones and Joints, Cutaneous Melanoma, Breast Invasive, Corpus Uteri and Uterus, NOS, Cervix Uteri, Ovary, Prostate, Testis, Urinary Bladder, Kidney/Renal Pelvis, Brain and Other Nervous System, Thyroid, Hodgkins Lymphoma, Non-Hodgkins Lymphoma, Myeloma, Leukemia, Mesothelioma, Kaposi Sarcoma, Other Invasive
Race Filter	White, Non Hispanic, White, Hispanic, Black, American Indian, Asian/Pacific Islander, Other
County Filter	County, Cochise, Pima, Pinal, Santa Cruz, Yuma
Data Grouped By	Cancer Sites, Sex
```


# R Resources


## Happy Git and GitHub for the useR

https://happygitwithr.com/


## Big Book of R


https://www.bigbookofr.com/?s=09
