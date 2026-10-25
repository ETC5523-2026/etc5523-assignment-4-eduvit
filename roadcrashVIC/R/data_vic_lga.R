#' Victorian local government area boundaries
#'
#' Polygon boundaries for the 87 local government areas (LGAs) in Victoria, including the eight unincorporated alpine
#' resort and island areas. Boundaries are simplified for mapping and are not suitable for precise boundary work.
#'
#' @format An `sf` object (a tibble with a geometry column) with 87 rows and 3 columns:
#' \describe{
#'   \item{lga_code}{(character) ABS LGA code. The eight unincorporated areas all share the code
#'     `29399`, so they cannot be given separate population figures.}
#'   \item{lga_name}{(character) LGA name in capitals, for example `MERRI-BEK`. Unincorporated areas end in `(UNINC)`.}
#'   \item{geometry}{(sfc_MULTIPOLYGON) Boundary, in longitude and latitude (WGS 84, EPSG:4326).}
#' }
#'
#' @source Department of Transport and Planning, State of Victoria,
#'   *Vicmap Admin - Local Government Area (LGA) Polygon Aligned to Property*
#'   (resource LGA_POLYGON, metadata ID cff349f9-3ef3-51bd-b5a9-ae650f6d6c24),
#'   published 16 October 2026, licensed under
#'   [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Retrieved 25 October 2026. <https://discover.data.vic.gov.au/dataset/vicmap-admin-local-government-area-lga-polygon-aligned-to-property>.
#'
#'   **Changes made:** only the ABS code and name columns were kept (renamed
#'   `lga_code` and `lga_name`); coordinates were converted from GDA2020 to
#'   WGS 84; geometry was simplified with a 100 m tolerance (the original is
#'   accurate to about 3 m); rows were sorted by name.
"vic_lga"