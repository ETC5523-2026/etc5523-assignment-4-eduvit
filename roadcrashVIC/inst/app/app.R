library(shiny)
library(shinyWidgets)
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
# Default "My area" period: the last 12 months
area_default_months <- c(month_starts[length(month_starts) - 11], max(month_starts))

measure_choices <- c("Crashes" = "crashes", "Killed or seriously injured (KSI)" = "ksi", "Deaths" = "fatalities")
scale_choices <- c("Count" = "count", "Per 100k residents" = "per_100k", "Per 1,000 crashes" = "per_1000")
when_choices <- c("Month" = "month", "Day of the week" = "day_of_week", "Hour of the day" = "hour")

# Labels for plots
measure_labels <- c(crashes = "Crashes", ksi = "KSI", fatalities = "Deaths")
scale_labels <- c(count = "", per_100k = " per 100,000 residents", per_1000 = " per 1,000 crashes")
road_title_words <- c(crashes = "crashes", ksi = "KSI", fatalities = "deaths")

# Edges of Victoria, to bound the maps
vic_bounds <- sf::st_bbox(vic_lga)

# Colour of crash points by severity
severity_pal <- colorFactor(c("#7f0000", "#e34a33", "#fdbb84"), levels = levels(vic_crashes$severity))

# Popup text of a crash on the map
crash_popup <- function(d){
  # "2 pedestrians", "1 pedestrian", or "" when the count is 0
  count_text <- function(n, word, plural = word) ifelse(n == 0, "", paste(n, ifelse(n == 1, word, plural)))
  # For each crash, join its non-empty pieces with commas
  join_parts <- function(...) apply(cbind(...), 1, function(x) paste(x[x != ""], collapse = ", "))

  # Plain wording for the light condition and the speed limit
  light_text <- c(
    "Day" = "daylight",
    "Dusk/Dawn" = "dusk or dawn",
    "Dark Street lights on" = "dark, street lights on",
    "Dark Street lights off" = "dark, street lights off",
    "Dark No street lights" = "dark, no street lights",
    "Dark Street lights unknown" = "dark, street lighting unknown"
  )
  speed <- as.character(d$speed_zone)
  speed <- ifelse(speed == "Off road", "Off-road location",
                  ifelse(speed == "Other", "Other speed limit", paste(speed, "speed limit")))

  title <- paste0("<b>", d$severity, ": ", tolower(d$accident_type), "</b>")
  date <- paste0( # in English on any computer
    d$day_of_week, ", ", as.integer(format(d$accident_date, "%d")), " ",
    month.abb[as.integer(format(d$accident_date, "%m"))], " ", format(d$accident_date, "%Y")
  )
  when_where <- paste0(
    date, ", ", sprintf("%02dh", d$hour), " - ",
    tools::toTitleCase(tolower(coalesce(d$road_full_name, "Unknown road"))), ", ",
    tools::toTitleCase(tolower(d$lga_name))
  )
  conditions <- paste0(
    coalesce(speed, "Unknown speed limit"), " - ",
    coalesce(unname(light_text[d$light_condition]), "light unknown")
  )
  people <- paste0(
    count_text(d$total_persons, "person", "people"), " involved: ",
    join_parts(
      count_text(d$fatality, "killed"),
      count_text(d$seriousinjury, "seriously injured"),
      count_text(d$otherinjury, "with other injuries")
    )
  )
  users <- join_parts(
    count_text(d$no_of_vehicles, "vehicle", "vehicles"),
    count_text(d$pedestrian, "pedestrian", "pedestrians"),
    count_text(d$bicyclist, "cyclist", "cyclists"),
    count_text(d$motorcyclist, "motorcyclist", "motorcyclists")
  )
  paste(title, when_where, conditions, people, users, sep = "<br>")
}

# Metric in the chosen scale
scaled_value <- function(d, measure, scale, population){
  if (scale == "count") value <- d[[measure]]
  if (scale == "per_100k") value <- 1e5 * d[[measure]] / population
  if (scale == "per_1000") value <- d[[paste0(measure, "_per_1000_crashes")]]
  value
}

# Value box number
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
        "Road crashes resulting in injury or death recorded by Victoria Police from ", year_range[1], " to ",
        year_range[2], ", for members of the public to explore across Victoria and in their local area."
      )
    )
  ),
  nav_panel(
    "Victoria",
    layout_sidebar(
      sidebar = sidebar(
        sliderInput(
          "vic_years", "Choose a time interval to analyse",
          min = year_range[1],
          max = year_range[2],
          value = year_range,
          step = 1,
          sep = ""
        ),
        selectInput(
          "vic_measure", "Choose a metric to analyse",
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
          card_footer("Select \"Per 1,000 crashes\" to compare severity across road users.")
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
          "area_lga", "Choose one or more LGAs to analyse (up to 15):",
          choices = sort(vic_lga$lga_name),
          multiple = TRUE,
          options = list(maxItems = 15, plugins = list("remove_button"))
        ),
        actionButton("area_clear_lga", "Clear LGAs"),
        airMonthpickerInput(
          "area_months", "Period:",
          range = TRUE,
          value = area_default_months,
          minDate = min(month_starts),
          maxDate = max(month_starts),
          dateFormat = "MMM yyyy",
          addon = "none"
        ),
        selectInput(
          "area_measure", "Choose a metric to analyse:",
          choices = measure_choices
        ),
        selectInput(
          "area_scale", "Show results as:",
          choices = c("Count" = "count", "Per 1,000 crashes" = "per_1000")
        ),
        selectInput(
          "area_road_user", "Show crashes involving:",
          choices = c("All road users" = "all", "Pedestrians" = "pedestrian", "Cyclists" = "cyclist", "Motorcyclists" = "motorcyclist")
        ),
        helpText(
          p("Selecting many LGAs or a long period may slow loading."),
          p("Rates per 100,000 residents are not available in this tab, because population figures are only published yearly."),
          p("The map and top roads show only the crashes matching the chosen metric (all, KSI or fatal)."),
          p("Selecting a road user shows the crashes involving them. It does not show how many of them were injured.")
        )
      ),
      textOutput("area_missing_note"),
      layout_column_wrap(
        width = 1/3,
        value_box(title = "Crashes", value = textOutput("area_crashes_box")),
        value_box(title = "KSI", value = textOutput("area_ksi_box")),
        value_box(title = "Deaths", value = textOutput("area_deaths_box"))
      ),
      layout_columns(
        col_widths = c(7, 5),
        card(
          full_screen = TRUE, height = 700,
          card_header("Where have crashes happened?"),
          leafletOutput("area_map", height = 600)
        ),
        card(
          full_screen = TRUE, height = 700,
          card_header(textOutput("area_roads_title")),
          tableOutput("area_top_roads")
        )
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
          plotOutput("area_vulnerable_chart"),
          card_footer("Select \"Per 1,000 crashes\" to compare severity across road users.")
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
  vic_data <- reactive(
    vic_crashes |>
      filter_crashes(
        start_date = paste0(input$vic_years[1], "-01-01"),
        end_date = paste0(input$vic_years[2], "-12-31")
      )
  )

  ## Yearly summary
  vic_summary_year <- reactive(
    crash_rates(vic_data(), vic_population, by = "year")
  )

  ## Residents over the selected years
  vic_population_total <- reactive(
    sum(vic_summary_year()$population)
  )

  ## No charts for crashes per 1,000 crashes
  vic_check <- reactive(
    validate(need(
      !(input$vic_measure == "crashes" & input$vic_scale == "per_1000"),
      "Every crash counts as 1,000 per 1,000 crashes: choose KSI or deaths."
    ))
  )

  ## Axis and legend label
  vic_label <- reactive(
    paste0(measure_labels[[input$vic_measure]], scale_labels[[input$vic_scale]])
  )

  ## "When?": one value per month/day/hour
  vic_when_data <- reactive({
    d <- summarise_crashes(vic_data(), by = input$vic_when)
    data.frame(
      when = d[[input$vic_when]],
      value = scaled_value(d, input$vic_measure, input$vic_scale, vic_population_total())
    )
  })

  ## "Who?": one value per road user
  vic_who_data <- reactive({
    d <- summarise_vulnerable(vic_data())
    data.frame(
      road_user = d$road_user,
      value = scaled_value(d, input$vic_measure, input$vic_scale, vic_population_total())
    )
  })

  ## Map: one value per LGA
  vic_map_data <- reactive({
    d <- crash_rates(vic_data(), vic_population, by = "lga_name")
    d$value <- scaled_value(d, input$vic_measure, input$vic_scale, d$population)

    # No rate per resident for the unincorporated area
    d$value[d$lga_name == "UNINCORPORATED VIC" & input$vic_scale == "per_100k"] <- NA

    left_join(vic_lga, d, by = "lga_name")
  })

  ## First row: value boxes
  output$vic_crashes_box <- renderText(box_value(vic_summary_year(), "crashes", input$vic_scale))
  output$vic_ksi_box <- renderText(box_value(vic_summary_year(), "ksi", input$vic_scale))
  output$vic_deaths_box <- renderText(box_value(vic_summary_year(), "fatalities", input$vic_scale))

  ## Second row: time trend
  output$vic_trend <- renderPlot({
    vic_check()
    d <- vic_summary_year()
    value <- scaled_value(d, input$vic_measure, input$vic_scale, d$population)
    trend <- data.frame(year = d$year, value = value, series = measure_labels[[input$vic_measure]])

    # Index: values and population, first year = 100
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
    ggplot(vic_when_data(), aes(x = when, y = value)) +
      geom_col() +
      labs(x = names(when_choices)[when_choices == input$vic_when], y = vic_label())
  })

  output$vic_vulnerable_chart <- renderPlot({
    vic_check()
    ggplot(vic_who_data(), aes(x = road_user, y = value)) +
      geom_col() +
      labs(x = NULL, y = vic_label())
  })

  ## Fourth row: map
  output$vic_map <- renderLeaflet({
    vic_check()
    d <- vic_map_data()
    pal <- colorNumeric("YlOrRd", domain = d$value)

    leaflet(d, options = leafletOptions(minZoom = 6)) |>
      addProviderTiles("Esri.WorldGrayCanvas") |>
      fitBounds(vic_bounds[["xmin"]], vic_bounds[["ymin"]], vic_bounds[["xmax"]], vic_bounds[["ymax"]]) |>
      setMaxBounds(vic_bounds[["xmin"]], vic_bounds[["ymin"]], vic_bounds[["xmax"]], vic_bounds[["ymax"]]) |>
      addPolygons(
        fillColor = ~pal(value),
        fillOpacity = 0.8,
        weight = 1,
        label = ~paste0(
          tools::toTitleCase(tolower(lga_name)), ": ",
          ifelse(is.na(value), "no value", format(round(value, 1), big.mark = ","))
        )
      ) |>
      addLegend(pal = pal, values = ~value, title = vic_label())
  })

  # "My area" tab
  ## "Clear LGAs" button
  observeEvent(input$area_clear_lga, {
    updateSelectizeInput(session, "area_lga", selected = character(0))
  })

  ## Last day of the period's last month
  area_end <- reactive({
    req(length(input$area_months) == 2) # wait until both months are picked
    seq(as.Date(input$area_months[2]), by = "month", length.out = 2)[2] - 1 # first day of next month, minus one day
  })

  ## Crashes in the selected LGAs and months
  area_data <- reactive({
    validate(need(input$area_lga, "Choose at least one LGA."))
    vic_crashes |>
      filter_crashes(start_date = input$area_months[1], end_date = area_end()) |>
      filter(lga_name %in% input$area_lga)
  })

  ## Road user filter (all outputs except "Who?")
  area_user_data <- reactive({
    d <- area_data()
    if (input$area_road_user == "pedestrian") d <- filter(d, involves_pedestrian)
    if (input$area_road_user == "cyclist") d <- filter(d, involves_cyclist)
    if (input$area_road_user == "motorcyclist") d <- filter(d, involves_motorcyclist)
    d
  })

  ## Summary of the whole selection
  area_summary_total <- reactive(
    summarise_crashes(area_user_data(), by = character(0))
  )

  ## Metric filter (map and top roads)
  area_map_data <- reactive({
    d <- area_user_data()
    if (input$area_measure == "ksi") d <- filter(d, severity != "Other injury accident")
    if (input$area_measure == "fatalities") d <- filter(d, severity == "Fatal accident")
    validate(need(nrow(d) > 0, "No crashes match this selection."))
    d
  })

  ## No charts for crashes per 1,000 crashes
  area_check <- reactive(
    validate(need(
      !(input$area_measure == "crashes" & input$area_scale == "per_1000"),
      "Every crash counts as 1,000 per 1,000 crashes: choose KSI or deaths."
    ))
  )

  ## Axis label
  area_label <- reactive(
    paste0(measure_labels[[input$area_measure]], scale_labels[[input$area_scale]])
  )

  ## Note above the value boxes
  output$area_missing_note <- renderText({
    d <- filter_crashes(vic_crashes, start_date = input$area_months[1], end_date = area_end())
    missing <- 100 * mean(is.na(d$lga_name))
    if (missing >= 3) paste0(round(missing), "% of crashes in this period have no recorded location and are not included.")
  })

  ## First row: value boxes
  output$area_crashes_box <- renderText(box_value(area_summary_total(), "crashes", input$area_scale))
  output$area_ksi_box <- renderText(box_value(area_summary_total(), "ksi", input$area_scale))
  output$area_deaths_box <- renderText(box_value(area_summary_total(), "fatalities", input$area_scale))

  ## Second row: map + top roads
  output$area_map <- renderLeaflet({
    d <- area_map_data()
    hover <- paste0(
      "<b>", d$day_of_week, ", ", format(d$accident_date, "%d/%m/%Y"), ": ", d$severity, "</b>",
      "<br>(click for additional details)"
    )
    outlines <- filter(vic_lga, lga_name %in% input$area_lga)
    box <- sf::st_bbox(outlines)

    leaflet(d, options = leafletOptions(minZoom = 6)) |>
      addTiles() |>
      fitBounds(box[["xmin"]], box[["ymin"]], box[["xmax"]], box[["ymax"]]) |>
      setMaxBounds(vic_bounds[["xmin"]], vic_bounds[["ymin"]], vic_bounds[["xmax"]], vic_bounds[["ymax"]]) |>
      addPolygons(data = outlines, fill = FALSE, color = "black", weight = 2) |>
      addCircleMarkers(
        lng = ~longitude,
        lat = ~latitude,
        radius = 6,
        stroke = FALSE,
        fillColor = ~severity_pal(severity),
        fillOpacity = 0.9,
        label = lapply(hover, HTML), # read the <b> and <br> tags in each label
        popup = crash_popup(d),
        popupOptions = popupOptions(maxWidth = 500),
        clusterOptions = markerClusterOptions(maxClusterRadius = 40, spiderfyDistanceMultiplier = 2)
      ) |>
      addLegend(pal = severity_pal, values = ~severity, title = "Severity")
  })

  output$area_roads_title <- renderText(
    paste0("Roads with the most ", road_title_words[[input$area_measure]], " (top 10)")
  )

  output$area_top_roads <- renderTable({
    d <- area_map_data() |>
      filter(!is.na(road_full_name), road_full_name != "UNNAMED") |>
      summarise_crashes(by = c("road_full_name", "lga_name"))
    d$value <- d[[input$area_measure]] # sort by the chosen metric, then by crashes

    top <- d |>
      arrange(desc(value), desc(crashes)) |>
      head(10)

    data.frame(
      Road = tools::toTitleCase(tolower(top$road_full_name)),
      LGA = tools::toTitleCase(tolower(top$lga_name)),
      Crashes = top$crashes,
      KSI = top$ksi,
      Deaths = top$fatalities
    )
  }, digits = 0)

  ## Third row: "When?" + "Who?"
  output$area_when_chart <- renderPlot({
    area_check()
    d <- summarise_crashes(area_user_data(), by = input$area_when)
    when <- data.frame(when = d[[input$area_when]], value = scaled_value(d, input$area_measure, input$area_scale, NA))
    # Months that appear more than once in the period make monthly counts uneven
    n_months <- length(seq(as.Date(input$area_months[1]), as.Date(input$area_months[2]), by = "month"))
    uneven <- input$area_when == "month" && input$area_scale == "count" && n_months %% 12 != 0

    ggplot(when, aes(x = when, y = value)) +
      geom_col() +
      labs(
        x = names(when_choices)[when_choices == input$area_when], y = area_label(),
        caption = if (uneven) "Note: some months appear more than once in the selected period and have higher bars." else NULL
      ) +
      theme(plot.caption = element_text(size = 12, hjust = 0), plot.caption.position = "plot")
  })

  output$area_vulnerable_chart <- renderPlot({
    area_check()
    validate(need(input$area_road_user == "all", "Choose \"All road users\" in \"Show crashes involving\" to compare road users."))
    d <- summarise_vulnerable(area_data())
    who <- data.frame(road_user = d$road_user, value = scaled_value(d, input$area_measure, input$area_scale, NA))

    ggplot(who, aes(x = road_user, y = value)) +
      geom_col() +
      labs(x = NULL, y = area_label())
  })
}

shinyApp(ui, server)
