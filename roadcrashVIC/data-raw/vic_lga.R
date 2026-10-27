## code to prepare `vic_lga` dataset goes here

shp_path <- "data-raw/raw/lga_polygon_files/LGA_POLYGON.shp"

vic_lga <- sf::read_sf(shp_path) |>
  dplyr::rename_with(tolower) |>
  dplyr::select(lga_code = abslgacode, lga_name) |>
  # The 8 alpine resorts and islands share one ABS code: give them one name
  dplyr::mutate(lga_name = dplyr::if_else(lga_code == "29399", "UNINCORPORATED VIC", lga_name)) |>
  sf::st_transform(7899) |>                 # metres, so the tolerance means metres
  dplyr::group_by(lga_code, lga_name) |>    # merges the 8 polygons into one
  dplyr::summarise(.groups = "drop") |>
  sf::st_simplify(preserveTopology = TRUE, dTolerance = 100) |>
  sf::st_transform(4326) |>                 # what Leaflet expects
  sf::st_make_valid() |>
  dplyr::mutate(unincorporated = lga_code == "29399") |>
  dplyr::arrange(lga_name)

usethis::use_data(vic_lga, overwrite = TRUE)
