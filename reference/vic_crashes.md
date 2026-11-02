# Victorian road crashes resulting in casualties, 2012 to 2025

One row per road crash in Victoria in which at least one person was
injured or killed, from 1 January 2012 to 31 December 2025, as recorded
by Victoria Police.

## Usage

``` r
vic_crashes
```

## Format

A tibble with 202,065 rows and 51 columns:

- accident_no:

  (character) Unique crash identifier.

- accident_date:

  (Date) Date of the crash.

- year:

  (integer) Year of the crash.

- month:

  (factor) Month of the crash, `Jan` to `Dec`.

- day_of_week:

  (factor) Day of the week, `Monday` to `Sunday`.

- hour:

  (integer) Hour of the day, 0 to 23 (17 means 5:00pm to 5:59pm).

- accident_type:

  (character) Type of crash, for example `Collision with vehicle` or
  `Struck Pedestrian`.

- dca_code_description:

  (character) Detailed crash type (Definitions for Classifying
  Accidents).

- light_condition:

  (character) Light at the time of the crash, for example `Day` or
  `Dark No street lights`.

- police_attend:

  (character) Whether police attended the scene (`Yes` or `No`).

- road_geometry:

  (character) Road layout, for example `T intersection` or
  `Not at intersection`.

- severity:

  (factor) Severity of the crash: `Fatal accident`,
  `Serious injury accident` or `Other injury accident`.

- speed_zone:

  (ordered factor) Speed limit, `30 km/h` to `110 km/h`, then `Off road`
  and `Other`.

- run_offroad:

  (character) Whether the vehicle ran off the road (`Yes` or `No`).

- road_full_name:

  (character) Road name and type, for example `Alfred Street`.

- lga_name:

  (character) Local government area (LGA), spelled as in
  [vic_lga](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_lga.md).

- dtp_region:

  (character) Department of Transport and Planning region.

- latitude:

  (numeric) Latitude of the crash.

- longitude:

  (numeric) Longitude of the crash.

- total_persons:

  (numeric) People involved.

- inj_or_fatal:

  (numeric) People killed or injured.

- fatality:

  (numeric) People killed.

- seriousinjury:

  (numeric) People seriously injured.

- otherinjury:

  (numeric) People with other injuries.

- noninjured:

  (numeric) People not injured.

- males:

  (numeric) Males involved.

- females:

  (numeric) Females involved.

- bicyclist:

  (numeric) Cyclists involved.

- passenger:

  (numeric) Passengers involved.

- driver:

  (numeric) Drivers involved.

- pedestrian:

  (numeric) Pedestrians involved.

- pillion:

  (numeric) Pillion passengers involved.

- motorcyclist:

  (numeric) Motorcyclists involved.

- unknown:

  (numeric) Road users of unknown type involved.

- ped_cyclist_5_12:

  (numeric) Pedestrians and cyclists aged 5 to 12 involved.

- ped_cyclist_13_18:

  (numeric) Pedestrians and cyclists aged 13 to 18 involved.

- old_ped_65_and_over:

  (numeric) Pedestrians aged 65 and over involved.

- old_driver_75_and_over:

  (numeric) Drivers aged 75 and over involved.

- young_driver_18_25:

  (numeric) Drivers aged 18 to 25 involved.

- no_of_vehicles:

  (numeric) Vehicles involved, including bicycles.

- heavyvehicle:

  (numeric) Heavy vehicles involved.

- passengervehicle:

  (numeric) Passenger vehicles involved.

- motorcycle:

  (numeric) Motorcycles involved.

- pt_vehicle:

  (numeric) Public transport vehicles involved (tram, bus or train).

- deg_urban_name:

  (character) How urban the location is, for example `MELB_URBAN` or
  `RURAL_VICTORIA`.

- rma:

  (character) Road classification, for example `Freeway` or
  `Local Road`.

- divided:

  (character) Whether the road is divided (`Divided` or `Undivided`).

- stat_div_name:

  (character) Statistical division (`Metro` or `Country`).

- involves_pedestrian:

  (logical) At least one pedestrian involved.

- involves_cyclist:

  (logical) At least one cyclist involved.

- involves_motorcyclist:

  (logical) At least one motorcyclist or pillion passenger involved.

## Source

Victorian Government (Department of Transport and Planning), *Victorian
road crash data*,
<https://discover.data.vic.gov.au/dataset/victoria-road-crash-data>,
licensed under [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/). Data last updated 13
October 2026; retrieved 25 October 2026.

**Changes made:** kept casualty crashes up to 31 December 2025; cleaned
column names; added `year`, `month`, `hour`, `road_full_name` and the
`involves_*` columns; converted categories to factors; set `Unk.`,
`Unknown` and `Not known` to `NA`; matched LGA names to
[vic_lga](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_lga.md);
removed `ACCIDENT_TIME`, `VICGRID_X`, `VICGRID_Y`, `ROAD_ROUTE_1`,
`ROAD_NAME`, `ROAD_TYPE`, `DCA_CODE` and `SRNS`.
