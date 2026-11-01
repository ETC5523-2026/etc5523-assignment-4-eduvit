# Filter crashes to a date range

Keep only the crashes that happened between two dates (both included).

## Usage

``` r
filter_crashes(
  data,
  start_date = min(data$accident_date),
  end_date = max(data$accident_date)
)
```

## Arguments

- data:

  A data frame of crashes with an `accident_date` column, such as
  [vic_crashes](https://etc5523-2026.github.io/etc5523-assignment-4-eduvit/reference/vic_crashes.md).

- start_date, end_date:

  First and last day to keep, as dates or `"YYYY-MM-DD"` strings.
  Default to the first and last date in `data`.

## Value

The rows of `data` between `start_date` and `end_date`, with the same
columns.

## Examples

``` r
# Crashes in the 2024-25 financial year
fy <- filter_crashes(vic_crashes, start_date = "2024-07-01", end_date = "2025-06-30")
nrow(fy)
#> [1] 15970

# Only a start date: everything from 2020 onwards
nrow(filter_crashes(vic_crashes, start_date = "2020-01-01"))
#> [1] 87650
```
