library(plumber)
log_info("Start handler")

#' Output depends on function.json
#' if it contains a "name":"$return " fields you should return a ReturnValue
#'
make_response <- function(Outputs, Logs, ReturnValue = NULL){
    res <- vector(mode="list",length = 3)
    names(res) <- c("Outputs","Logs","ReturnValue")
    res$Outputs <- list('res' = Outputs)
    res$Logs <- Logs
    res$ReturnValue <- ReturnValue
    res
}


#* @post /CRONtrigger
function(req, res) {
    log_info("recieving on CRONtrigger")
    # This is where you would put functions or calls to other files.
    source("run_job.R")
        make_response(
            ## Add or change things in this  response
            Outputs = list(
                body="done",
                invocation_id=req$HTTP_X_AZURE_FUNCTIONS_INVOCATIONID
                ),
            Logs = readLines("log.txt"),
            ReturnValue = "timertrigger"
        )
}
