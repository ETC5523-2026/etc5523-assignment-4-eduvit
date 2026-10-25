#' Victorian road crashes resulting in casualties, 2012 to 2026
#'
#' One row per road crash in Victoria that resulted in at least one person being injured or killed, from 1 January 2012
#' to 28 February 2026. Crashes are recorded by Victoria Police; coordinates and region are missing for about 1,300 crashes.
#'
#' @format A tibble with 202,297 rows and 48 columns:
#' \describe{
#'   \item{accident_no}{(character) ACCIDENT NO is the Primary Key for the database to uniquely identify the accident and cannot contain NULL values. First character T indicates TIS incident and characters 2-5 typically represent the year in which the accident created in TIS system and characters 6-11 are a numeric sequencing number}
#'   \item{accident_date}{(Date) Date when the accident occurred}
#'   \item{year}{(numeric) Calendar year of the crash, taken from `accident_date`.}
#'   \item{month}{(factor) Month of the crash as a factor (`Jan` to `Dec`), taken from `accident_date`.}
#'   \item{day_of_week}{(factor) The field indicates the day of the week upon which the accident occurred}
#'   \item{hour}{(integer) Hour of the day the crash happened (0 to 23, where 17 means 5:00pm to 5:59pm), taken from the original `ACCIDENT_TIME`.}
#'   \item{accident_type}{(character) Is a character field indicates the type of accident. It is a basic description of what occurred, based on nine categories. E.g. Collision with Vehicle}
#'   \item{dca_code_description}{(character) This field indicates the text from the Definitions for Classifying Accidents.}
#'   \item{light_condition}{(character) Indicates the light condition or level of brightness at the time of the accident. This field cannot contain NULL values.}
#'   \item{police_attend}{(character) Indicates whether the police attended the scene of the accident or not.}
#'   \item{road_geometry}{(character) Code for layout of the road where the accident occurred}
#'   \item{severity}{(factor) Estimation of the severity or seriousness of the accident}
#'   \item{speed_zone}{(character) The speed zone at the location of the accident. The speed zone is generally assigned to the main vehicle involved.}
#'   \item{run_offroad}{(character) If the crash is considered a run off road (DCA Codes: 151, 170-173, 180-183)}
#'   \item{road_full_name}{(character) Road name and road type joined together (for example `Alfred Street`). `NA` when the road name is missing.}
#'   \item{lga_name}{(character) LGA NAME is a character field contains the LGA name for the location of the crash}
#'   \item{dtp_region}{(character) This field indicates the administrative Department of Transport and Planning (DTP) region}
#'   \item{latitude}{(numeric) Geographical coordinates}
#'   \item{longitude}{(numeric) Geographical coordinates}
#'   \item{total_persons}{(numeric) The number of people involved in the accident}
#'   \item{inj_or_fatal}{(numeric) The number of people involved in the accident killed or injured}
#'   \item{fatality}{(numeric) Number of people who have died in the crash}
#'   \item{seriousinjury}{(numeric) Number of people with a serious injury}
#'   \item{otherinjury}{(numeric) Number of people with an other injury}
#'   \item{noninjured}{(numeric) Number of people with no injuries}
#'   \item{males}{(numeric) Number of males involved in the crash}
#'   \item{females}{(numeric) Number of females involved in the crash}
#'   \item{bicyclist}{(numeric) Number of bicyclists involved in the crash}
#'   \item{passenger}{(numeric) Number of passengers involved in the crash}
#'   \item{driver}{(numeric) Number of drivers involved in the crash}
#'   \item{pedestrian}{(numeric) Number of pedestrians involved in the crash}
#'   \item{pillion}{(numeric) Number of pillion passengers involved in the crash}
#'   \item{motorcyclist}{(numeric) Number of motorcyclists involved in the crash}
#'   \item{unknown}{(numeric) Number of unknown road users involved in the crash}
#'   \item{ped_cyclist_5_12}{(numeric) Number of pedestrians and cyclists between the ages 5 and 12}
#'   \item{ped_cyclist_13_18}{(numeric) Number of pedestrians and cyclists between the ages 13 and 18}
#'   \item{old_ped_65_and_over}{(numeric) Number of pedestrians aged 65 and over}
#'   \item{old_driver_75_and_over}{(numeric) Number of drivers aged 75 and older}
#'   \item{young_driver_18_25}{(numeric) Number of drivers aged between 18 and 25}
#'   \item{no_of_vehicles}{(numeric) The number of vehicles involved in the accident. Includes bicycles but not objects, property, toys (skate boards), etc.}
#'   \item{heavyvehicle}{(numeric) Number of heavy vehicles involved in the crash}
#'   \item{passengervehicle}{(numeric) Number of passenger vehicles involved in the crash}
#'   \item{motorcycle}{(numeric) Number of motorcycles involved in the crash}
#'   \item{pt_vehicle}{(numeric) Number of public transport vehicles involved in the crash (tram, bus, train)}
#'   \item{deg_urban_name}{(character) DEG URBAN NAME is a character field indicates degree of urban name for the location of the crash.}
#'   \item{rma}{(character) RMA Classification of the road contains VicRoads road classification.}
#'   \item{divided}{(character) DIVIDED is a character field indicating divided portion of road.}
#'   \item{stat_div_name}{(character) STAT DIV NAME is a character field indicates statistical division name for the location of the crash.}
#' }
#' @source Victorian Government (Department of Transport and Planning),
#'   *Victorian road crash data*,
#'   <https://opendata.transport.vic.gov.au/>, licensed under
#'   [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Data last updated 13 October 2026; retrieved 25 ottobre 2026.
#'
#'   **Changes made:** column names were cleaned; `year`, `month`, `hour` and `road_full_name` were added; text categories were
#'   converted to factors; placeholder values such as `Unk.` and `Not known` were set to `NA`; and the columns `ACCIDENT_TIME`,
#'  `VICGRID_X`, `VICGRID_Y`, `ROAD_ROUTE_1`, `ROAD_NAME`, `ROAD_TYPE`, `DCA_CODE` and `SRNS` were removed. 
"vic_crashes"
