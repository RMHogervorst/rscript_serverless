library(rtweet)
library(ggplot2)
library(glue)

source("functions.R")

#* @post /CRONtrigger
function(req, res) {
  log_info("recieving on CRONtrigger")
  fail_on_missing_variables()
  ## authenticate and get token
  token <- get_token()
  # create data for plot
  dataset <- create_curve()
  settings <- create_settings()
  tmp <- tempfile(fileext = ".png")
  create_plot(tmp, dataset = dataset, settings = settings)
  post_tweet(
    status = paste0(
      settings$title, " #invertedushape",
      " This post came from: ",
      Sys.getenv("LOCATION"),
      " ",
      Sys.getenv("REPO")
    ),
    media = tmp,
    token = token
  )
  log_info("Tweet posted")
  make_response(
    ## Add or change things in this  response
    Outputs = list(
      body = "done",
      invocation_id = req$HTTP_X_AZURE_FUNCTIONS_INVOCATIONID
    ),
    Logs = readLines("log.txt"),
    ReturnValue = "timertrigger"
  )
}
