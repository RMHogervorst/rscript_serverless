## General development process

I'm mixing and matching from 2 tutorials: [revodavid examples with plumber](https://github.com/revodavid/R-custom-handler) and the [basic R tutorial on azure](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?tabs=bash%2Cportal&pivots=programming-language-other#create-supporting-azure-resources-for-your-function).

### Tools
Use the command line tools to create settings and configs.

* install both Azure functions core tools AND azure CLI.
* check versions (`az --version`) & (`func --version`)
* log in (`az login` ; opens a browser window)

```
The following tenants require Multi-Factor Authentication (MFA). Use 'az login --tenant TENANT_ID' to explicitly login to a tenant.

```

* make sure docker is running
* `docker login`

* Create a local custom functions project: `func init LocalFunctionsProject --worker-runtime custom --docker`

* Creates .gitignore, host.json, local.settings.json, .vscode/extensions.json. dockerfile. and docker ignore.

### start on the R side

* start an Rstudio project in the folder 'LocalFunctionsProject'
* execute renv::init() to set up renv
* create function.json `func new --name TimerRtrigger --template "timer trigger"` (For example timer trigger template)
* modify the function. (F.i. timing of cron trigger so it runs on 2300 hours.)
* Add an rscript that will create the plumber api

```r
#library(logger) if you like good logging
library(plumber)
#log_appender(appender_file("log.txt"))
#log_threshold(INFO)

PORTEnv <- Sys.getenv("FUNCTIONS_CUSTOMHANDLER_PORT",unset = NA)
if(is.na(PORTEnv)){PORTEnv <- 80}
PORT <- strtoi(PORTEnv , base = 0L)
#log_info("Running on port {PORT}")
pr("handle-this.R") %>%
    pr_run(port=PORT)
```
* modify host.json so it calls Rscript and the name of your script

```
"customHandler": {
    "description": {
      "defaultExecutablePath": "Rscript",
      "workingDirectory": "",
      "arguments": [
        "run_job.R"
      ]
    }
  }
```

* add a script that will be 'plumbed' (handle-this.R for example)
* add basic logic for plumber  (so it responds to correct verb (GET, POST) and correct endpoint (the name of folder in project /NAME_OF_FOLDER))

```
#* @post /CRONtrigger
function(req, res) {
 make_response(
    ## Add or change things in this  response
    Outputs = list(
      body = "done",
      invocation_id = req$HTTP_X_AZURE_FUNCTIONS_INVOCATIONID
    ),
    Logs = c(""), # readLines("log.txt"), # when you use logger this will send the logs so far as a response back
    ReturnValue = "something"
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
```

* `func start` to make it work on your local R session

### Putting it all in a Docker container

* Modify the Dockerfile to change R version if you need to, install system requirements for your packages, setup {renv}, copy files to `/home/site/wwwroot` in the docker container
* test your dockerfile locally with docker run or docker-compose (if you need storage emulation I would recommend docker-compose)
* set the timing to correct values for what you want, you might want to test every 5 minutes but maybe not in production (you can change this later)

* push container to registry of choice

### Creating resources in azure
Now we go on to creating the resources in azure

* Choose name for resource group, also choose a name for your function and a storage account to host assets. (globally unique, so you can't use these)

```sh
FR_LOC="westeurope"
FR_RG="R-u-curve-timer"
FR_FUNCTION="rucurvetimerfunc"
FR_STORAGE="rucurvetimerstrg"
```

* create group  `az group create --name ${FR_RG} --location ${FR_LOC}`  returns a json with status.


* create storage account `az storage account create --name $FR_STORAGE --location $FR_LOC --resource-group $FR_RG --sku Standard_LRS` (takes quite a long while to create)

* create resource group  `az functionapp plan create --resource-group $FR_RG --name myPremiumPlan --location $FR_LOC --number-of-workers 1 --sku EP1 --is-linux` (also takes a while)

* create functionapp `az functionapp create --functions-version 2 --name $FR_FUNCTION --storage-account $FR_STORAGE --resource-group $FR_RG --plan myPremiumPlan --runtime custom --deployment-container-image-name rmhogervorst/azurefunctionsimage:v1.0.0` --tags environment=production


* configure the app

```sh
storageConnectionString=$(az storage account show-connection-string --resource-group $FR_RG --name $FR_STORAGE --query connectionString --output tsv)
az functionapp config appsettings set --name $FR_FUNCTION --resource-group $FR_RG --settings AzureWebJobsStorage=$storageConnectionString
```

* add env variables to to azure in settings/configuration via the web portal or change them with the `az functionapp config appsettings set command`


*enable continuous deployment *

* retrieve webhook `az functionapp deployment container config --enable-cd --query CI_CD_URL --output tsv --name  $FR_FUNCTION --resource-group $FR_RG`

* go to registry and add webhook
