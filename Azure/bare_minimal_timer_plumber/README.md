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

I ran a new docker container that simulates being azure storage.
`docker run -p 10000:10000 -p 10001:10001 mcr.microsoft.com/azure-storage/azurite`  and now the service starts.


The trigger calls out to `/<NAME YOU GAVE THE FUNCTION>` which makes sense, but I have not seen documented. 
