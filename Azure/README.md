# Azure functions

## General development process
see [general development_process.md](general_development_process.md).

## Timer trigger
I want to run the function on a timer trigger, which isconsiderably more 
difficult than the http trigger. In fact I could not get the httpuv version working.

* [x] [Example bare minimal timer with plumber and renv](bare_minimal_timer/)
* [] [example minimal timer using only httpuv](bare_minimal_httpuv)
* [x] [example of timer trigger, with plumber and logging implemented](plumber_run_script)
* [x] [cleaned up version of plumber r script so debugging is easier](plumber_cleaned_up) This is currently a working function that tweets [as @invertedushape1 ](https://twitter.com/invertedushape1/status/1350042047701544965)

### Lessons learned
* the timer trigger requires storage account, which you can mock with [azurite]()
* testing your custom docker container works easiest with docker-compose
* microsoft ships really really old containers, so be ready to install a recent R version on those containers
* timer triggers do a POST request on the route that matches the name of your folder (in my case CRONtrigger -> /CRONtrigger)
* You need to respond with a json that contains 'Outputs', 'Logs' and sometimes a 'ReturnValue' (this is easily done in {plumber}, but I couldn't get it to work in {httpuv})  [docs about response](https://docs.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers#response-payload) It expects a certain response: a json with three keys: Outputs, Logs, ReturnValue.
* All messages are interpreted as Failures in the logs (because messages and failures etc from Rscript are all send to stderr), so it is nicer to capture all messages and write them to a log file that you send back in the response so they end up in the logs in the way you want them to.
* You can set [very detailed logging levels for default, host. function etc.](https://docs.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)
* Run the docker container, supplying the [.Renviron secrets](https://notes.rmhogervorst.nl/post/2020/09/23/passing-cmd-line-arguments-to-your-rocker-container/) `docker run --env-file .Renviron <name_of_container>`
* you can supply secrets to docker-compose with the setting `env_file:`


### Thoughts
* Maybe we should start with a rocker container and install the function tools on top of that, so at least R is working perfectly and all the settings are fine?


