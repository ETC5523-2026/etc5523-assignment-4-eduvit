## code to prepare `vic_crashes` dataset goes here

raw_path <- "data-raw/raw/victorian_road_crash_data.csv"

if (!file.exists(raw_path)) {
  url <- paste0(
    "https://opendata.transport.vic.gov.au/dataset/",
    "bb77800e-1857-4edc-bf9e-e188437a1c8e/resource/",
    "5df1f373-0c90-48f5-80e1-7b2a35507134/download/",
    "victorian_road_crash_data.csv"
  )
  utils::download.file(url, raw_path)
}

speed_levels <- c(paste(c(30, 40, 50, 60, 70, 75, 80, 90, 100, 110), "km/h"), "Off road", "Other")

vic_crashes <- readr::read_csv(raw_path, show_col_types = FALSE) |>
  janitor::clean_names() |>
  # Keep complete years with population data, and casualty crashes only
  dplyr::filter(accident_date <= as.Date("2025-12-31"), severity != "Non injury accident") |>
  tidyr::unite("road_full_name", road_name, road_type, sep = " ", na.rm = TRUE, remove = FALSE) |>
  dplyr::mutate(
    dplyr::across( # Modify unknown values in different columns to NA
      c(speed_zone, light_condition, road_geometry, police_attend),
      \(x) dplyr::na_if(x, "Not known") |> dplyr::na_if("Unk.") |> dplyr::na_if("Unknown")
    ),
    # "60 km/hr" -> "60 km/h", then order the speed zones
    speed_zone = stringr::str_replace(speed_zone, " ?km/hr", " km/h"),
    speed_zone = dplyr::case_when(
      speed_zone == "Camping grounds or off road" ~ "Off road",
      speed_zone == "Other speed limit" ~ "Other",
      .default = speed_zone
    ),
    speed_zone = factor(speed_zone, levels = speed_levels, ordered = TRUE),
    # Match the LGA names used in vic_lga
    lga_name = dplyr::case_when(
      lga_name %in% c("BENDIGO", "DANDENONG", "GEELONG", "SHEPPARTON") ~ paste("GREATER", lga_name),
      lga_name == "MORELAND" ~ "MERRI-BEK",
      stringr::str_starts(lga_name, "\\(") ~ "UNINCORPORATED VIC",   # e.g. "(FALLS CREEK)"
      .default = lga_name
    ),
    road_full_name = dplyr::na_if(road_full_name, ""),
    hour = stringr::str_sub(accident_time, 1, 2) |> as.integer(),
    year = lubridate::year(accident_date) |> as.integer(),
    month = factor(lubridate::month(accident_date), levels = 1:12, labels = month.abb),
    day_of_week = factor(day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")),
    severity = factor(severity, levels = c("Fatal accident", "Serious injury accident", "Other injury accident")),
    # Vulnerable road users involved in the crash
    involves_pedestrian = pedestrian > 0,
    involves_cyclist = bicyclist > 0,
    involves_motorcyclist = motorcyclist + pillion > 0
  ) |>
  dplyr::select(-accident_time, -vicgrid_x, -vicgrid_y, -road_route_1, -road_name, -road_type, -dca_code, -srns) |>
  dplyr::relocate(accident_no, accident_date, year, month, day_of_week, hour)

usethis::use_data(vic_crashes, overwrite = TRUE)
