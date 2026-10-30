library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(leaflet)
library(sf)
library(roadcrashVIC)

year_range <- range(vic_crashes$year)

month_starts <- seq(
  as.Date(format(min(vic_crashes$accident_date), "%Y-%m-01")),
  max(vic_crashes$accident_date),
  by = "month"
)
# Names are shown to the user ("Jan 2012"), values are sent to the server ("2012-01-01")
month_choices <- setNames(as.character(month_starts), format(month_starts, "%b %Y"))

measure_choices <- c("Crashes" = "crashes", "Killed or seriously injured (KSI)" = "ksi", "Deaths" = "fatalities")
scale_choices <- c("Count" = "count", "Per 100k residents" = "per_100k", "Per 1,000 crashes" = "per_1000")
when_choices <- c("Month" = "month", "Day of the week" = "day_of_week", "Hour of the day" = "hour")

# Labels for plots
measure_labels <- c(crashes = "Crashes", ksi = "KSI", fatalities = "Deaths")
scale_labels <- c(count = "", per_100k = " per 100,000 residents", per_1000 = " per 1,000 crashes")

# Edges of Victoria, to bound the map's zoom
vic_bounds <- sf::st_bbox(vic_lga)

# The chosen metric in the chosen scale, from a summary table
scaled_value <- function(d, measure, scale, population){
  if (scale == "count") value <- d[[measure]]
  if (scale == "per_100k") value <- 1e5 * d[[measure]] / population
  if (scale == "per_1000") value <- d[[paste0(measure, "_per_1000_crashes")]]
  value
}

# One number for a value box, from the yearly summary
box_value <- function(d, measure, scale){
  if (measure == "crashes" & scale == "per_1000") return("-") # always 1,000
  count <- d[[measure]]
  if (scale == "count") value <- sum(count) # total over the years
  if (scale == "per_100k") value <- 1e5 * sum(count) / sum(d$population) # average yearly rate
  if (scale == "per_1000") value <- 1000 * sum(count) / sum(d$crashes)
  digits <- if (scale == "count") 0 else 1
  format(round(value, digits), big.mark = ",", nsmall = digits)
}

ui <- page_navbar(
  id = "main_nav",
  title = "Victoria Road Crash Explorer",
  fillable = FALSE, # let the page scroll
  header = list(
    p(
      class = "mb-1",
      strong(paste0(
        "How have road crashes in Victoria changed since ", year_range[1], "? ",
        "Where do most crashes happen, when are they most frequent, and which road users are most vulnerable?"
      ))
    ),
    p(
      paste0(
        "This dashboard presents the road crashes resulting in injury or death recorded by Victoria Police ",
        "from ", year_range[1], " to ", year_range[2], ", to help members of the public explore these questions ",
        "across the state and within their local area."
      )
    )
  ),
  nav_panel(
    "Victoria",
    layout_sidebar(
      sidebar = sidebar(
        sliderInput(
          "vic_years", "Choose a time interval to analyze",
          min = year_range[1],
          max = year_range[2],
          value = year_range,
          step = 1,
          sep = ""
        ),
        selectInput(
          "vic_measure", "Choose a metric to analyze",
          choices = measure_choices
        ),
        selectInput(
          "vic_scale", "Show results as:",
          choices = scale_choices
        ),
        helpText(
          "Definitions of each metric and scale, and notes on the data, are in the",
          actionLink("vic_go_about", "About"), "tab."
        )
      ),
      layout_column_wrap(
        width = 1/3,
        value_box(title = "Crashes", value = textOutput("vic_crashes_box")),
        value_box(title = "KSI", value = textOutput("vic_ksi_box")),
        value_box(title = "Deaths", value = textOutput("vic_deaths_box"))
      ),
      card(
        full_screen = TRUE, height = 500,
        card_header("How has it changed?"),
        checkboxInput("vic_index", "Compare with population growth (first year = 100)"),
        plotOutput("vic_trend")
      ),
      layout_column_wrap(
        width = 1/2,
        height = 500,
        card(
          full_screen = TRUE,
          card_header("When do crashes happen most?"),
          selectInput("vic_when", NULL, choices = when_choices),
          plotOutput("vic_when_chart")
        ),
        card(
          full_screen = TRUE,
          card_header("Who is the most vulnerable road user?"),
          plotOutput("vic_vulnerable_chart"),
          card_footer("Choose \"Per 1,000 crashes\" to compare how serious crashes are for each road user.")
        )
      ),
      card(
        full_screen = TRUE, height = 700,
        card_header("Where do crashes happen most?"),
        leafletOutput("vic_map", height = 600)
      )
    )
  ),
  nav_panel(
    "My area",
    layout_sidebar(
      sidebar = sidebar(
        selectizeInput(
          "area_lga", "Choose one or multiple LGA to analyze",
          choices = sort(vic_lga$lga_name),
          multiple = TRUE
        ),
        selectInput(
          "area_from", "From:",
          choices = month_choices,
          selected = month_choices[length(month_choices) - 11] # last 12 months by default
        ),
        selectInput(
          "area_to", "To:",
          choices = month_choices,
          selected = month_choices[length(month_choices)]
        ),
        selectInput(
          "area_severity", "Severity of accident:",
          choices = c("All crashes" = "all", "Fatal + serious" = "ksi")
        ),
        selectInput(
          "area_road_user", "Road user",
          choices = c("All" = "all", "Pedestrian" = "pedestrian", "Cyclist" = "cyclist", "Motorcycle riders" = "motorcyclist")
        ),
        selectInput(
          "area_scale", "Show results as:",
          choices = c("Count" = "count", "Per 1,000 crashes" = "per_1000")
        ),
        helpText(
          p("One or more LGAs can be selected."),
          p("\"Fatal + serious\" hides crashes in which no one was killed or seriously injured."),
          p("\"Road user\" shows crashes in which at least one road user of that category was involved.",
            "It does not show how many of them were injured.")
        )
      ),
      layout_column_wrap(
        width = 1/3,
        value_box(title = "Crashes", value = textOutput("area_crashes_box")),
        value_box(title = "KSI", value = textOutput("area_ksi_box")),
        value_box(title = "Deaths", value = textOutput("area_deaths_box"))
      ),
      layout_column_wrap(
        width = 1/2,
        height = 700,
        card(full_screen = TRUE, card_header("Where have accidents happened?"), leafletOutput("area_map")),
        card(full_screen = TRUE, card_header("Top 5 roads"), tableOutput("area_top_roads"))
      ),
      layout_column_wrap(
        width = 1/2,
        height = 500,
        card(
          full_screen = TRUE,
          card_header("When do crashes happen most?"),
          selectInput("area_when", NULL, choices = when_choices),
          plotOutput("area_when_chart")
        ),
        card(
          full_screen = TRUE,
          card_header("Who is the most vulnerable road user?"),
          plotOutput("area_vulnerable_chart")
        )
      )
    )
  ),
  nav_panel(
    "About",
    markdown(readLines("about.md")) # text in inst/app/about.md
  )
)

server <- function(input, output, session){
  # "About" tab
  observeEvent(input$vic_go_about, nav_select("main_nav", "About"))

  # "Victoria" tab
  ## Crashes in the selected years
  custom_year_data <- reactive(
    vic_crashes |>
      filter_crashes(
        start_date = paste0(input$vic_years[1], "-01-01"),
        end_date = paste0(input$vic_years[2], "-12-31")
      )
  )

  ## One row per year: counts, and rates per 100k residents
  crash_summary_year <- reactive(
    crash_rates(custom_year_data(), vic_population, by = "year")
  )

  ## Residents summed over the selected years, for rates per 100k
  vic_population_total <- reactive(
    sum(crash_summary_year()$population)
  )

  ## Crashes per 1,000 crashes is always 1,000: no chart for it
  vic_check <- reactive(
    validate(need(
      !(input$vic_measure == "crashes" & input$vic_scale == "per_1000"),
      "Every crash counts as 1,000 per 1,000 crashes: choose KSI or deaths."
    ))
  )

  ## Label for the chosen metric and scale, e.g. "KSI per 100,000 residents"
  vic_label <- reactive(
    paste0(measure_labels[[input$vic_measure]], scale_labels[[input$vic_scale]])
  )

  ## "When?": one value per month/day/hour
  when_data <- reactive({
    d <- summarise_crashes(custom_year_data(), by = input$vic_when)
    data.frame(
      when = d[[input$vic_when]],
      value = scaled_value(d, input$vic_measure, input$vic_scale, vic_population_total())
    )
  })

  ## "Who?": one value per road user
  who_data <- reactive({
    d <- summarise_vulnerable(custom_year_data())
    data.frame(
      road_user = d$road_user,
      value = scaled_value(d, input$vic_measure, input$vic_scale, vic_population_total())
    )
  })

  ## Map: one value per LGA
  map_data <- reactive({
    d <- crash_rates(custom_year_data(), vic_population, by = "lga_name")
    d$value <- scaled_value(d, input$vic_measure, input$vic_scale, d$population)

    # No rate per resident for the unincorporated area
    d$value[d$lga_name == "UNINCORPORATED VIC" & input$vic_scale == "per_100k"] <- NA

    left_join(vic_lga, d, by = "lga_name")
  })

  ## First row: value boxes
  output$vic_crashes_box <- renderText(box_value(crash_summary_year(), "crashes", input$vic_scale))
  output$vic_ksi_box <- renderText(box_value(crash_summary_year(), "ksi", input$vic_scale))
  output$vic_deaths_box <- renderText(box_value(crash_summary_year(), "fatalities", input$vic_scale))

  ## Second row: time trend
  output$vic_trend <- renderPlot({
    vic_check()
    d <- crash_summary_year()
    value <- scaled_value(d, input$vic_measure, input$vic_scale, d$population)
    trend <- data.frame(year = d$year, value = value, series = measure_labels[[input$vic_measure]])

    # Index: the values and the population relative to the first year, to compare the two
    if (input$vic_index) {
      trend$value <- 100 * trend$value / trend$value[1]
      population <- data.frame(year = d$year, value = 100 * d$population / d$population[1], series = "Population")
      trend <- rbind(trend, population)
    }

    ggplot(trend, aes(x = year, y = value, colour = series)) +
      geom_point() +
      geom_line() +
      scale_x_continuous(breaks = d$year) +
      labs(x = "Year", y = if (input$vic_index) "Index (first year = 100)" else vic_label(), colour = NULL) +
      theme(legend.position = if (input$vic_index) "bottom" else "none")
  })

  ## Third row: "When?" + "Who?"
  output$vic_when_chart <- renderPlot({
    vic_check()
    ggplot(when_data(), aes(x = when, y = value)) +
      geom_col() +
      labs(x = names(when_choices)[when_choices == input$vic_when], y = vic_label())
  })

  output$vic_vulnerable_chart <- renderPlot({
    vic_check()
    ggplot(who_data(), aes(x = road_user, y = value)) +
      geom_col() +
      labs(x = NULL, y = vic_label())
  })

  ## Fourth row: map
  output$vic_map <- renderLeaflet({
    vic_check()
    pal <- colorNumeric("YlOrRd", domain = map_data()$value)

    leaflet(map_data(), options = leafletOptions(minZoom = 6)) |>
      addProviderTiles("CartoDB.PositronNoLabels") |>
      fitBounds(vic_bounds[["xmin"]], vic_bounds[["ymin"]], vic_bounds[["xmax"]], vic_bounds[["ymax"]]) |>
      setMaxBounds(vic_bounds[["xmin"]], vic_bounds[["ymin"]], vic_bounds[["xmax"]], vic_bounds[["ymax"]]) |>
      addPolygons(
        fillColor = ~pal(value),
        fillOpacity = 0.8,
        weight = 1,
        label = ~paste0(lga_name, ": ", ifelse(is.na(value), "no value", format(round(value, 1), big.mark = ",")))
      ) |>
      addLegend(pal = pal, values = ~value, title = vic_label())
  })

  # "My Area" Tab
  # One row per selected lga_name
  crash_summary_where <- reactive(
    custom_year_data() |> summarise_crashes(by = input$area_lga)
  )

  output$area_crashes_box <- renderText(
    format(crash_summary_where()$crashes, big.mark = ",")
  )
  output$area_ksi_box <- renderText(
    format(crash_summary_where()$ksi, big.mark = ",")
  )
  output$area_deaths_box <- renderText(
    format(crash_summary_where()$fatalities, big.mark = ",")
  )
}

shinyApp(ui, server)
