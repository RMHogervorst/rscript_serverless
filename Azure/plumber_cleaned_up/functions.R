# fail on missing env vars
missing_env <- function(key) {
  result <- is.na(Sys.getenv(key, unset = NA_character_))
  if (result) log_warn(paste0("Missing env var: ", key))
  result
}

fail_on_missing_variables <- function() {
  if (any(
    missing_env("apikey"),
    missing_env("apisecretkey"),
    missing_env("access_token"),
    missing_env("access_token_secret")
  )) {
    log_error("credentials not found")
    stop("credentials not found")
  }
}

create_curve <- function() {
  point_len <- sample(c(20, 25, 30, 35, 40), 1)
  points <- seq_len(point_len)
  halfpoint <- median(points)
  offset_ <- round(rnorm(1) * 4)
  noise <- rnorm(n = point_len, mean = halfpoint, sd = sqrt(halfpoint))

  data.frame(
    x = points,
    y = -(points - halfpoint)^2 + offset_ + noise
  )
}

get_token <- function() {
  create_token(
    app = "tweetashape",
    consumer_key = Sys.getenv("apikey"),
    consumer_secret = Sys.getenv("apisecretkey"),
    access_token = Sys.getenv("access_token"),
    access_secret = Sys.getenv("access_token_secret"),
    set_renv = FALSE
  )
}



#' Output depends on function.json
#' if it contains a "name":"$return " field you should return a ReturnValue
#'
make_response <- function(Outputs, Logs, ReturnValue = NULL) {
  res <- vector(mode = "list", length = 3)
  names(res) <- c("Outputs", "Logs", "ReturnValue")
  res$Outputs <- list("res" = Outputs)
  res$Logs <- Logs
  res$ReturnValue <- ReturnValue
  res
}

create_settings <- function() {
  settings <- list()
  settings$x <- sample(
    c(
      "Resources", "Ideas", "Chapter", "Interaction", "Complexity",
      "Market Saturation", "Cooking Hours", "Number of Exclamation marks",
      "Amount of things on the todo list", "Inequality", "Aging",
      "Female Participation Ratio", "Bro-ness", "Saltiness"
    ),
    1
  )
  settings$y <- sample(
    c(
      "Maintenance", "Fun", "#People", "Entertainment", "Effort",
      "Judgement", "Membership", "Celebration", "Height", "Insanity",
      "Motivation", "Innovation", "Temperature",
      "Polution", "Hemline", "Intelligence", "Friends"
    ),
    1
  )
  settings$subtitle <- sample(c(
    "  Who knew?", "  It is a curve!",
    "  Who knew?", "  It is a curve!",
    "  Who knew?", "  It is a curve!",
    "  It is not as if this is just random data"
  ), 1)
  settings$title <- glue("  {settings$y} by {settings$x} is an inverted u-shape")
  # color settings
  settings$color_ <- sample(c("#30445b", "#32305b", "#30595b"),1)
  settings$background_color <- sample(c("#ffffe6", "#FFCC99", "#ffe5e5", "#e5ffe5", "#e5e5ff"), 1)
  log_info(glue("using \"{settings$title}\" with foreground: {settings$color_} and background: {settings$background_color}"))
  settings
}

create_plot <- function(tmp, dataset, settings) {
  # plot the plot
  p <-
    ggplot(dataset, aes(x, y)) +
    geom_smooth(
      method = "loess", formula = "y~x",
      span = 0.6,
      se = FALSE,
      position = position_jitter(height = 0.05),
      size = 2.5,
      color = settings$color_
    ) +
    theme_light(base_size = 15) +
    labs(
      title = settings$title,
      subtitle = settings$subtitle,
      x = settings$x,
      y = settings$y,
      caption = "automagically created by @invertedushape1  "
    ) +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      plot.margin = margin(2, 2, 2, 2),
      plot.background = element_rect(fill = settings$background_color),
      panel.background = element_rect(fill = settings$background_color),
      plot.caption = element_text(face = "italic"),
      axis.title.x = element_text(hjust = 0.4),
      axis.title.y = element_text(hjust = 0.4),
      plot.subtitle = element_text(family = "serif", face = "italic")
    )

  ggsave(tmp, plot = p, width = 9, height = 6)
}
