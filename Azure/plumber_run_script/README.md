# Running a script on functions


## Creating a docker container
You could also build the container with docker-compose, but rebuilding everytime is very slow. I rather build it once and run the build image.

For reasons only Microsoft knows, their images install very old versions
of R (3.5). So this build takes a while the first time, because we need to install R 3.0.4 from source. The next steps (installing all the required packages also takes a while).

`docker build --tag rmhogervorst/azuretimerrscript:v0.0.1 .`


#### Docker compose notes
[see the docker-compose.yml file](docker-compose.yml) There are 2 services; 'storage' and 'serverless'. Storage is the emulator called azurite. serverless is the container I created locally with docker build. I pass the environmental variable in the docker compose file: `environment:` Instead of the ip adress (localhost; `BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;`) I supply it the name of the other container ('storage'): `BlobEndpoint=http://storage:10000/devstoreaccount1;`. That way you don't have to know what the internal IP address is within the docker compose environment. 


## Run docker compose with azurite
(also supply required env vars for run_job.R with .Renviron file locally. Inside the docker-compose file I refer to the file)
`docker-compose  up`

It takes a few seconds for the storage container to start until it is ready the other container sprays some errors. Wait for 10 seconds or so and it starts to run normally. 

Stop the process with `ctrl+c` 


### Trigger endpoint
The trigger calls out to `/<NAME YOU GAVE THE FUNCTION>` which makes sense, but I have not seen documented. 

So because I used `func new --name CRONtrigger --template "timer trigger"`
you have to respond to /CRONtrigger.

d
