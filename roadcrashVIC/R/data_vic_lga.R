#' Victorian local government area boundaries
#'
#' Simplified boundaries of the local government areas (LGAs) in Victoria, for mapping.
#'
#' @format An `sf` object (a tibble with a geometry column) with 80 rows and 4 columns:
#' \describe{
#'   \item{lga_code}{(character) ABS LGA code.}
#'   \item{lga_name}{(character) LGA name in capitals, for example `MERRI-BEK`.}
#'   \item{unincorporated}{(logical) `TRUE` for the unincorporated areas (alpine resorts and islands).}
#'   \item{geometry}{(sfc_MULTIPOLYGON) Boundary, in longitude and latitude (WGS 84).}
#' }
#'
#' @source Department of Transport and Planning, State of Victoria,
#'   *Vicmap Admin - Local Government Area (LGA) Polygon Aligned to Property*
#'   (resource LGA_POLYGON, metadata ID cff349f9-3ef3-51bd-b5a9-ae650f6d6c24),
#'   published 16 October 2026, licensed under
#'   [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
#'   Retrieved 25 October 2026. <https://discover.data.vic.gov.au/dataset/vicmap-admin-local-government-area-lga-polygon-aligned-to-property>.
#'
#'   **Changes made:** kept the ABS code and name; merged the unincorporated areas into one `UNINCORPORATED VIC`
#'   feature; added `unincorporated`; converted to WGS 84; simplified with a 100 m tolerance; sorted by name.
"vic_lga"
