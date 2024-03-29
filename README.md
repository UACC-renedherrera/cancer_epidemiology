Click here to read the documentation: https://uacc-renedherrera.github.io/cancer_epidemiology/


# Cancer Epidemiology


## Description


This project intends to describe cancer epidemiology in Arizona using data from the following 3 sources:


- United States Cancer Statistics.
- Arizona Cancer Registry Database Query Module.
- Surveillance, Epidemiology, and End Results (SEER) Program (https://seer.cancer.gov/) SEER*Stat Database.


To produce tables and visualizations to compare and contrast differences in cancer incidence and mortality.


- United States
- Arizona
- University of Arizona Cancer Center (UAZCC) Catchment
- Arizona Counties
- UAZCC Catchment Counties
- Hispanic, non-Hispanic, and American Indian populations


## Start Here


The [USCS data tidy script](/scripts/USCS_data_tidy.R) will download data from the CDC.gov website and prepare it for further analysis. Four RDS files will be generated to describe incidence and mortality by:


- cancer
- age
- state
- states and counties


These data files can be processed in the [USCS data processing](/scripts/USCS_data_processing.R) script.


## Data Sources


### ADHS IBIS PH


The Arizona Department of Health Services (ADHS) Indicator Based Information System for Public Health (IBIS-PH) system allows the public to query cancer rates, mortality rates and population estimates for Arizona. These public health data sets are intended to support evidenced-based decision making in Arizona to plan and improve service delivery, evaluate health care systems, and inform policy decisions. Other uses are not permissible. Available at http://healthdata.az.gov/query/module_selection/azcr/AzCRSelection.html


### United States Cancer Statistics


National Program of Cancer Registries and Surveillance, Epidemiology, and End Results SEER*Stat Database: NPCR and SEER Incidence – U.S. Cancer Statistics Public Use Research Database, 2019 submission (2001–2017), United States Department of Health and Human Services, Centers for Disease Control and Prevention and National Cancer Institute. Released June 2020. Available at https://www.cdc.gov/cancer/uscs/public-use/.


### SEER*Stat Databases: November 2019 Submission


Surveillance, Epidemiology, and End Results (SEER) Program (https://seer.cancer.gov/) SEER*Stat Database: Mortality - All COD, Aggregated With County, Total U.S. (1990-2018) <Katrina/Rita Population Adjustment> - Linked To County Attributes - Total U.S., 1969-2018 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released May 2020.  Underlying mortality data provided by NCHS (https://www.cdc.gov/nchs/).


## Examples of R Markdown Reports and Dashboards


On RPubs: https://rpubs.com/UAZCC_Rene


## File naming


Tidy data files should follow the following naming pattern, separated by underscore:


`"event type"_"geography"_"data source"_"year-range"_"other details"`
