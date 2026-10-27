## code to prepare `vic_population` dataset goes here

data_file <- "data-raw/raw/population_data_lga.csv"

vic_population <- readr::read_csv(data_file, show_col_types = FALSE) |>
  janitor::clean_names() |>
  # Victorian LGAs only (region type also drops the state total, code "2")
  dplyr::filter(
    region_type == "LGA2025",
    stringr::str_sub(region, 1, 1) == "2",
    time_period >= 2012, time_period <= 2025
  ) |>
  dplyr::select(lga_code = region, lga_name = region_2, year = time_period, population = obs_value) |>
  dplyr::mutate(
    lga_code = as.character(lga_code),
    # "Bayside (Vic.)" -> "BAYSIDE", to match vic_lga and vic_crashes
    lga_name = stringr::str_remove(toupper(lga_name), " \\(VIC\\.\\)"),
    year = as.integer(year)
  )

usethis::use_data(vic_population, overwrite = TRUE)
