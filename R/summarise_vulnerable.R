#' Summarise crashes involving vulnerable road users
#'
#' Applies [summarise_crashes()] to all crashes, and to the crashes involving a pedestrian, a cyclist or a motorcyclist.
#'
#' @param data A data frame of crashes, such as [vic_crashes], optionally filtered with [filter_crashes()].
#'
#' @return A tibble with four rows (`All crashes`, `Pedestrian`, `Cyclist`, `Motorcyclist`):
#'   a `road_user` column, then the columns of [summarise_crashes()].
#' 
#' @examples
#' summarise_vulnerable(vic_crashes)
#' 
#' @export
summarise_vulnerable <- function(data){
  dplyr::bind_rows(
    "All crashes" = summarise_crashes(data, by = character(0)),
    "Pedestrian" = summarise_crashes(dplyr::filter(data, involves_pedestrian), by = character(0)),
    "Cyclist" = summarise_crashes(dplyr::filter(data, involves_cyclist), by = character(0)),
    "Motorcyclist" = summarise_crashes(dplyr::filter(data, involves_motorcyclist), by = character(0)),
    .id = "road_user"
  )
}