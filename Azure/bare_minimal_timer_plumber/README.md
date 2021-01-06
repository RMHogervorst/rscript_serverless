## bare minimal R example
I made it too complicated before.

` func init bare_minimal_timer --worker-runtime custom --docker`

move in the folder

`func new --name CRONtrigger --template "timer trigger"`

in R : `env::init()`

create an R file handler.R (copied from example)
save. install packages

run `renv::snapshot()`

test it out locally. Unfortunately this is super weird. You need to simulate
storage for func to work. But the error is not clear. (I'm using a mac for this
)  it says: the listener for function <NAME of your function> was unable to start. System.Private.CoreLib: A task was cancelled. 


### Simulating azure storage 
I ran a new docker container that simulates being azure storage.
[explananation of Azurite](https://github.com/azure/azurite)
`docker run -p 10000:10000 -p 10001:10001 mcr.microsoft.com/azure-storage/azurite`  and now the service starts.

Or you can use an your actual account. Using your storage account / settings/ Access keys

### Trigger endpoint
The trigger calls out to `/<NAME YOU GAVE THE FUNCTION>` which makes sense, but I have not seen documented. 

So because I used `func new --name CRONtrigger --template "timer trigger"`
you have to respond to /CRONtrigger.

mcr.microsoft.com/azure-functions/base:3.0-appservice is recent.
Docker container uses debian buster. (dec 5 2020)

`docker build --tag rmhogervorst/azurefunctiontimer:v1.0.0 .`


`docker run  -p  8080:80 -it  rmhogervorst/azurefunctiontimer:v1.0.0`


notices this in the docs https://github.com/azure/azurite#http-connection-strings
no effect

