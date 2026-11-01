# Summarise crashes involving vulnerable road users

Applies
[`summarise_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/summarise_crashes.md)
to all crashes, and to the crashes involving a pedestrian, a cyclist or
a motorcyclist.

## Usage

``` r
summarise_vulnerable(data)
```

## Arguments

- data:

  A data frame of crashes, such as
  [vic_crashes](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_crashes.md),
  optionally filtered with
  [`filter_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/filter_crashes.md).

## Value

A tibble with four rows (`All crashes`, `Pedestrian`, `Cyclist`,
`Motorcyclist`): a `road_user` column, then the columns of
[`summarise_crashes()`](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/summarise_crashes.md).

## Examples

``` r
summarise_vulnerable(vic_crashes)
#> # A tibble: 4 × 10
#>   road_user    crashes fatalities serious_injuries other_injuries   ksi
#>   <chr>          <int>      <dbl>            <dbl>          <dbl> <dbl>
#> 1 All crashes   202065       3607            83956         174970 87563
#> 2 Pedestrian     17696        562             8244          11140  8806
#> 3 Cyclist        19593        146             6450          13983  6596
#> 4 Motorcyclist   28362        634            13752          15865 14386
#> # ℹ 4 more variables: fatalities_per_1000_crashes <dbl>,
#> #   serious_injuries_per_1000_crashes <dbl>,
#> #   other_injuries_per_1000_crashes <dbl>, ksi_per_1000_crashes <dbl>
```
