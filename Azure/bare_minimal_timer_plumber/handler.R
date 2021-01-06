
library(plumber)
PORTEnv <- Sys.getenv("FUNCTIONS_CUSTOMHANDLER_PORT",unset = NA)
if(is.na(PORTEnv)){PORTEnv <- 80}
PORT <- strtoi(PORTEnv , base = 0L)

pr("handle-this.R") %>%
    pr_run(port=PORT)
