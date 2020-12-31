library(jsonlite)
library(plumber)


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
    message("recieving on CRONtrigger")
    # This is where you would put functions or calls to other files.
        make_response(
            ## Add or change things in this  response
            Outputs = list(
                body="done",
                invocation_id=req$HTTP_X_AZURE_FUNCTIONS_INVOCATIONID
                ),
            Logs = c("logmessage1",as.character(Sys.time()), "Another log message"),
            ReturnValue = "timertrigger"
        )
}
