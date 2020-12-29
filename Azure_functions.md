## Azure functions
Following [tutorial create custom function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal&WT.mc_id=aiml-11825-davidsmi)

* installed both Azure functions core tools AND azure CLI.
* check versions (`az --version`) & ()
* log in (`az login` ; opens a browser window)

```
The following tenants require Multi-Factor Authentication (MFA). Use 'az login --tenant TENANT_ID' to explicitly login to a tenant.

```

* make sure docker is runnning
* `docker login`

* Create a local custom functions project: `func init LocalFunctionsProject --worker-runtime custom --docker`

* Creates .gitignore, host.json, local.settings.json, .vscode/extensions.json. dockerfile. and docker ignore.

* create function.json `func new --name TimerRtrigger --template "timer trigger"` (using timer trigger template)

* modified the timer. so it runs on 2300 hours.
* Added a script
* modified host.json  this part:

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


`func start` (fails)

`docker build --tag <DOCKER_ID>/azurefunctionsimage:v1.0.0 .`

`docker build --tag rmhogervorst/azurefunctionsimage:v1.0.0 .`

docker run 

Run the docker container, supplying the [.Renviron secrets](https://notes.rmhogervorst.nl/post/2020/09/23/passing-cmd-line-arguments-to-your-rocker-container/)

"docker run --env-file .Renviron <name>"

`docker run --env-file .Renviron rmhogervorst/azurefunctionsimage:v1.0.0 Rscript run_job.R`



Things I did not think about before that came up:

- The functions container expects the host.json and files to be in /home/site/wwwroot
- 
