# Serverless for R
(This page is maintained on [github](https://github.com/rmhogervorst/rscript_serverless) and [gitlab](https://gitlab.com/rmhogervorst/rscript_serverless) and 
[codeberg](https://codeberg.org/rmhogervorst/rscript_serverless)
)
My attempts to run serverless functions on cloud providers.

## What is serverless (or Functions as a Service (FaaS))
Serverless is a misleading name, there are servers, but we don't care about them
at all. It is also called functions as a service (FaaS). 

Idea is that you have to write less code[^1], have to maintain less infrastructure, and you only pay for execution time. It also scales out automatically: if you have 1100 incoming requests at the same time, 1100 functions are activated (within certain constraints) and respond to each request.

Ideally everything is already taken care of for you. You only write the code that needs to be executed and the serverless system takes care of everything else (machine, enough memory, cpu, etc).

The promiss of serverless is: your function is run for you and you only pay
for execution time (per second or microsecond even).


## What to search for at the large providers
On the three major cloud providers serverless is called:

* [Amazon] : *AWS* Lambda
* [Microsoft](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal&WT.mc_id=aiml-11825-davidsmi) : *Azure* Functions
* [Google] : *GCP*  Cloud functions

### Supported languages
Usually only the largest languages are supported: Javascript (Node), Python, Java, Go, PowerShell, C#, Ruby 

* AWS: Javascript (Node), Python, Java, Go, PowerShell, C#, Ruby , and custom
* Azure: .NET core (C#), Javascript (node), F#, Java, PowerShell, Typescript, Python, and in preview (so not ready for production yet: Custom handlers)

* GCP: Node, Python, Go, Java, .NET

But there are in most cases also custom runtimes that you can prepare and upload to use. Most often you use a docker container provided by the company and build on top of that.


## Pros and cons
([See also my post](https://blog.rmhogervorst.nl/blog/2020/09/26/running-an-r-script-on-a-schedule-overview/ "Running an R script on a schedule") and [overview page on github](https://github.com/RMHogervorst/scheduling_r_scripts) about running Rscripts.)

Serverless is not useful for everything, (you pay per second, or microsecond, so) fast things are way cheaper than longer running things. In fact you are severely limited in time by cloud providers.
For example Azure by default has a timeout of 5 minutes, so if your function takes longer; the process is stopped. 


**When should you consider serverless:**

* You want to process (web) requests that are spiky (sometimes a lot, sometimes very little)
* Also database inserts, process message cues, scheduled tasks, events, streams
* atomic tasks (things that are done or not in one go and do not depend on other things)


**When should you not use serverless?**

* If your functions are long running (~5 minutes or more)
* If you need to run these functions regularly, for instance every 5 minutes (it is probably cheaper to rent a VM and run it on there)
* If you need super fast responses all the time, serverless is not great, if your function has laid dormant for a while, it will take some time to start again (cold start)
* Complex tasks
* Functions that depend on some sort of internal state
* Tasks that require high resources

### Current usecase
I created a script that creates a curve, makes a plot and creates a tweet
that is posted on twitter. I have several versions running at the moment see
my [my post about running an R script in the cloud](https://blog.rmhogervorst.nl/blog/2020/09/26/running-an-r-script-on-a-schedule-overview/ "Running an R script on a schedule").
My example script is slightly more complicated than other examples you see
on the web because I want it to be more useful. It can:

- install specific R package versions using Renv
- generate data 
- call out to an API
- logs what it does

This way it does more than 'hello world' and makes your IT people (and you) happy because the R packages are versioned and there is a trace from logging.
It does make the image somewhat big though.



### Resources

### AWS 
* [Main AWS page about Lambda](https://aws.amazon.com/lambda/)
* [An r-bloggers post in 2019 about running R on AWS lambda](https://www.r-bloggers.com/2019/07/how-to-use-r-in-aws-lambda/ "original lost in time")
* [AWS runtime created by Appsilon](https://github.com/Appsilon/r-lambda-workflow)

### Azure
Example projects with R. 
See the subfolder [Azure](Azure/) in this repo, it contains [a simple timer trigger script using {renv} and {plumber}](Azure/bare_minimal_timer_plumber/), and [an example project that runs another script](Azure/plumber_run_script/), and [an example project that has the same functionality but the entire thing is refactored into one funtional unit](Azure/plumber_cleaned_up/). 

#### Azure Links
* [Great practical example of R on Azure Functions in a custom runtime by RevoDavid](https://blog.revolutionanalytics.com/2020/12/azure-functions-with-r.html)[(Repo here)](https://github.com/revodavid/R-custom-handler).
* [Azure docs about custom handler (Which you need for R)](https://docs.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers#overview)

### GCP
x

#### Other solutions 
I'm a big fan of heroku. With heroku you can make an equivalent process and they hold your hand much more. Heroku runs your code in small containers called dynos.



## Footnotes
[^1]: With the amount of work I have to do to make a custom runtime work, I don't think we write less code at this moment for R.
