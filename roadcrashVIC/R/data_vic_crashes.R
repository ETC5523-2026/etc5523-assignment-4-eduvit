#' Victorian road crashes resulting in casualties, 2012 to 2025
#'
#' One row per road crash in Victoria in which at least one person was injured or killed,
#' from 1 January 2012 to 31 December 2025, as recorded by Victoria Police.
#'
#' @format A tibble with 202,065 rows and 51 columns:
#' \describe{
#'   \item{accident_no}{(character) Unique crash identifier.}
#'   \item{accident_date}{(Date) Date of the crash.}
#'   \item{year}{(integer) Year of the crash.}
#'   \item{month}{(factor) Month of the crash, `Jan` to `Dec`.}
#'   \item{day_of_week}{(factor) Day of the week, `Monday` to `Sunday`.}
#'   \item{hour}{(integer) Hour of the day, 0 to 23 (17 means 5:00pm to 5:59pm).}
#'   \item{accident_type}{(character) Type of crash, for example `Collision with vehicle` or `Struck Pedestrian`.}
#'   \item{dca_code_description}{(character) Detailed crash type (Definitions for Classifying Accidents).}
#'   \item{light_condition}{(character) Light at the time of the crash, for example `Day` or `Dark No street lights`.}
#'   \item{police_attend}{(character) Whether police attended the scene (`Yes` or `No`).}
#'   \item{road_geometry}{(character) Road layout, for example `T intersection` or `Not at intersection`.}
#'   \item{severity}{(factor) Severity of the crash: `Fatal accident`, `Serious injury accident` or `Other injury accident`.}
#'   \item{speed_zone}{(ordered factor) Speed limit, `30 km/h` to `110 km/h`, then `Off road` and `Other`.}
#'   \item{run_offroad}{(character) Whether the vehicle ran off the road (`Yes` or `No`).}
#'   \item{road_full_name}{(character) Road name and type, for example `Alfred Street`.}
#'   \item{lga_name}{(character) Local government area (LGA), spelled as in [vic_lga].}
#'   \item{dtp_region}{(character) Department of Transport and Planning region.}
#'   \item{latitude}{(numeric) Latitude of the crash.}
#'   \item{longitude}{(numeric) Longitude of the crash.}
#'   \item{total_persons}{(numeric) People involved.}
#'   \item{inj_or_fatal}{(numeric) People killed or injured.}
#'   \item{fatality}{(numeric) People killed.}
#'   \item{seriousinjury}{(numeric) People seriously injured.}
#'   \item{otherinjury}{(numeric) People with other injuries.}
#'   \item{noninjured}{(numeric) People not injured.}
#'   \item{males}{(numeric) Males involved.}
#'   \item{females}{(numeric) Females involved.}
#'   \item{bicyclist}{(numeric) Cyclists involved.}
#'   \item{passenger}{(numeric) Passengers involved.}
#'   \item{driver}{(numeric) Drivers involved.}
#'   \item{pedestrian}{(numeric) Pedestrians involved.}
#'   \item{pillion}{(numeric) Pillion passengers involved.}
#'   \item{motorcyclist}{(numeric) Motorcyclists involved.}
#'   \item{unknown}{(numeric) Road users of unknown type involved.}
#'   \item{ped_cyclist_5_12}{(numeric) Pedestrians and cyclists aged 5 to 12 involved.}
#'   \item{ped_cyclist_13_18}{(numeric) Pedestrians and cyclists aged 13 to 18 involved.}
#'   \item{old_ped_65_and_over}{(numeric) Pedestrians aged 65 and over involved.}
#'   \item{old_driver_75_and_over}{(numeric) Drivers aged 75 and over involved.}
#'   \item{young_driver_18_25}{(numeric) Drivers aged 18 to 25 involved.}
#'   \item{no_of_vehicles}{(numeric) Vehicles involved, including bicycles.}
#'   \item{heavyvehicle}{(numeric) Heavy vehicles involved.}
#'   \item{passengervehicle}{(numeric) Passenger vehicles involved.}
#'   \item{motorcycle}{(numeric) Motorcycles involved.}
#'   \item{pt_vehicle}{(numeric) Public transport vehicles involved (tram, bus or train).}
#'   \item{deg_urban_name}{(character) How urban the location is, for example `MELB_URBAN` or `RURAL_VICTORIA`.}
#'   \item{rma}{(character) Road classification, for example `Freeway` or `Local Road`.}
#'   \item{divided}{(character) Whether the road is divided (`Divided` or `Undivided`).}
#'   \item{stat_div_name}{(character) Statistical division (`Metro` or `Country`).}
#'   \item{involves_pedestrian}{(logical) At least one pedestrian involved.}
#'   \item{involves_cyclist}{(logical) At least one cyclist involved.}
#'   \item{involves_motorcyclist}{(logical) At least one motorcyclist or pillion passenger involved.}
#' }
#'
#' @source Victorian Government (Department of Transport and Planning),
#'   *Victorian road crash data*,
#'   <https://discover.data.vic.gov.au/dataset/victoria-road-crash-data>,
#'   licensed under
#'   [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Data last updated 13 October 2026; retrieved 25 October 2026.
#'
#'   **Changes made:** kept casualty crashes up to 31 December 2025; cleaned column names; added `year`, `month`,
#'   `hour`, `road_full_name` and the `involves_*` columns; converted categories to factors; set `Unk.` and `Not known` to `NA`; matched LGA
#'   names to [vic_lga]; removed `ACCIDENT_TIME`, `VICGRID_X`, `VICGRID_Y`, `ROAD_ROUTE_1`, `ROAD_NAME`, `ROAD_TYPE`,
#'   `DCA_CODE` and `SRNS`.
"vic_crashes"
