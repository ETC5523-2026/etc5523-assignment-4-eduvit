## code to prepare `population_vic` dataset goes here

data_file <- "data-raw/raw/population_data_lga.csv"

vic_population <- readr::read_csv(data_file, show_col_types=FALSE) |>
  janitor::clean_names() |>
  dplyr::filter(stringr::str_sub(region, 1, 1)=="2", time_period>=2012) |> 
  dplyr::select(lga_code=region, lga_name=region_2, year=time_period, population=obs_value)

usethis::use_data(vic_population, overwrite = TRUE)
