library(httpuv)
## it is slightly more than bare minimal,
## I'm copying the example here 
## https://github.com/Azure-Samples/functions-custom-handlers/blob/master/R/rserver.R
## 
## 
## This is not yet working for reasons I'm not sure about.
PORTEnv <- Sys.getenv("FUNCTIONS_CUSTOMHANDLER_PORT",unset = NA)
if(is.na(PORTEnv)){PORTEnv <- 80}
PORT <- strtoi(PORTEnv , base = 0L)

http_not_found <- list(
    status=404,
    body='404 Not Found'
)
http_method_not_allowed <- list(
    status=405,
    body='405 Method Not Allowed'
)

handler <- list(
    POST = function(request) {
        jsonlite::toJSON(list(
            Outputs=list('res'="an output"),
            Logs = c("logmessage1", as.character(Sys.time())),
            ReturnValue=NULL
                ))
    }
)
## we need to respond to /CRONtrigger
routes <- list(
    "/CRONtrigger" = handler
)

router <- function (routes, request) {
    # Pick the right handler for this path and method.
    # Respond with 404s and 405s if the handler isn't found.
    if (!request$PATH_INFO %in% names(routes)) {
        return(http_not_found)
    }
    path_handler <- routes[[request$PATH_INFO]]
    
    if (!request$REQUEST_METHOD %in% names(path_handler)) {
        return(http_method_not_allowed)
    }
    method_handler <- path_handler[[request$REQUEST_METHOD]]
    
    return(method_handler(request))
}

app <- list(
    call = function (request) {
        return(jsonlite::toJSON(list(
            Outputs=list('res'="an output"),
            Logs = c("logmessage1", as.character(Sys.time())),
            ReturnValue=NULL
        )))
    }
)


cat(paste0("Server listening on :", PORT, "...\n"))
runServer("0.0.0.0", PORT, app)
