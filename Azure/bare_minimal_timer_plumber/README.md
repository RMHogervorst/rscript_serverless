## bare minimal R example
I made it too complicated before.

` func init bare_minimal_timer --worker-runtime custom --docker`

move in the folder

`func new --name CRONtrigger --template "timer trigger"`

in R : `env::init()`

create an R file handler.R (copied from example)
save. install packages

run `renv::snapshot()`

test it out locally. 
`func start`


Unfortunately this is super weird. You need to simulate
storage for func to work. (Because Azure functions use storage to make sure there is only one function running at the same time for the Cron trigger) 
But the error is not clear. (I'm using a mac for this
)  it says: the listener for function <NAME of your function> was unable to start. System.Private.CoreLib: A task was cancelled. 


### Simulating azure storage 
You can simulate storage by using the Azurite docker container or  you can use an your actual account. Using your storage account / settings/ Access keys.
Azurite simulates azure storage for local work.
[explananation of Azurite](https://github.com/azure/azurite)
`docker run -p 10000:10000 -p 10001:10001 mcr.microsoft.com/azure-storage/azurite` 

if you now try it out locally with `func start` it will work.


## Creating a docker container
Notice that this doesn't work for you, because you are not rmhogervorst, so
replace this with something that works for you.

`docker build --tag rmhogervorst/azurefunctiontimer:v1.0.0 .`

#### Passing storage details to docker container
You also need to pass an environmental variable to the serverless container to tell the function where to find and where to authenticate to the storage container. see [connection-strings in the azurite docs](https://github.com/azure/azurite#connection-strings).

`docker run  -e "AzureWebJobsStorage"="DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;" -p 8080:80 -it <NAME_OF_YOUR_LOCAL_CONTAINER>`

I pass it one environmental variable with the name 'AzureWebJobsStorage', that variable has several parts, concatenated together. protocol, accountname, key, blobendpoint, etc. It refers to 127.0.0.1 here, that is localhost, that is on this same computer. When this container runs in the cloud, Azure provides different values so that it makes use of Azure storage (this is done for you, you don't need to supply it).

### Simulating storage for the docker container
You would think that the two docker containers, the docker container with your
serverless function and the one with the azure storage simulation would be able
to find each other, but I found it rather hard to make it work. 

There are several ways to do it, but ultimately I think
it is easiest to use `docker-compose` to spin up the two containers and make sure they are able to communicate with each other (Containers within docker compose by default are able to communicate with each other). 




#### Docker compose notes
[see the docker-compose.yml file](docker-compose.yml) There are 2 services; 'storage' and 'serverless'. Storage is the emulator called azurite. serverless is the container I created locally with docker build. I pass the environmental variable in the docker compose file: `environment:` Instead of the ip adress (localhost; `BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;`) I supply it the name of the other container ('storage'): `BlobEndpoint=http://storage:10000/devstoreaccount1;`. That way you don't have to know what the internal IP address is within the docker compose environment. 

`docker-compose up`

It takes a few seconds for the storage container to start untill it is ready the other container sprays some errors. Wait for 10 seconds or so and it starts to run normally. 

Stop the process with `ctrl+c` 


### Trigger endpoint
The trigger calls out to `/<NAME YOU GAVE THE FUNCTION>` which makes sense, but I have not seen documented. 

So because I used `func new --name CRONtrigger --template "timer trigger"`
you have to respond to /CRONtrigger.


