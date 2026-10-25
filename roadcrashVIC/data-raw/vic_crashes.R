## code to prepare `vic_crashes` dataset goes here

raw_path <- "data-raw/victorian_road_crash_data.csv"

if (!file.exists(raw_path)) {
  url <- paste0(
    "https://opendata.transport.vic.gov.au/dataset/",
    "bb77800e-1857-4edc-bf9e-e188437a1c8e/resource/",
    "5df1f373-0c90-48f5-80e1-7b2a35507134/download/",
    "victorian_road_crash_data.csv"
  )
  utils::download.file(url, raw_path)
}

vic_crashes <- readr::read_csv(raw_path, show_col_types=FALSE) |> 
  janitor::clean_names() |>
  tidyr::unite("road_full_name", road_name, road_type, sep=" ", na.rm=TRUE, remove=FALSE) |> 
  dplyr::mutate(
    dplyr::across( # Modify unknown values in different columns to NA
      c(speed_zone, light_condition, road_geometry, police_attend),
      \(x) dplyr::na_if(x, "Not known") |> dplyr::na_if("Unk.") |> dplyr::na_if("Unknown")
    ),
    road_full_name=dplyr::na_if(road_full_name, ""),
    hour = stringr::str_sub(accident_time, 1, 2) |> as.integer(),
    year = lubridate::year(accident_date),
    month = factor(lubridate::month(accident_date), levels = 1:12, labels = month.abb),
    day_of_week = factor(day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")),
    severity = factor(severity, levels=c("Fatal accident", "Serious injury accident", "Other injury accident", "Non injury accident")),
    ) |> 
  dplyr::select(-accident_time, -vicgrid_x, -vicgrid_y, -road_route_1, -road_name, -road_type, -dca_code, -srns) |>
  dplyr::relocate(accident_no, accident_date, year, month, day_of_week, hour)
  
usethis::use_data(vic_crashes, overwrite=TRUE)
