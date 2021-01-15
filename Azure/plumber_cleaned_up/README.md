# Running a script on functions
[back to main azure page](../Azure/README.md)

This is a working account that tweets [as @invertedushape1 ](https://twitter.com/invertedushape1/status/1350042047701544965)
with the text 'This post came from: azure function on timer trigger'.

## Creating a docker container 
`docker build --tag rmhogervorst/azuretimertweet:v0.0.1 .`
You could also build the container with docker-compose, but rebuilding 
every time is very slow. I rather build it once and run the build image.

For reasons only Microsoft knows, their images install very old versions
of R (3.5). So this build takes a while the first time, because we need to 
install R 3.0.4 from source. 
The next steps (installing all the required packages also takes a while).
I needed a recent version of R because the matrix package I depend on in the 
renv.lock is
higher and needs a higher R version. 



#### Docker compose notes
[see the docker-compose.yml file](docker-compose.yml) There are 2 services; 'storage' and 'function'. Storage is the emulator called azurite. serverless is the container I created locally with docker build. I pass the environmental variable in the docker compose file: `environment:` Instead of the ip adress (localhost; `BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;`) I supply it the name of the other container ('storage'): `BlobEndpoint=http://storage:10000/devstoreaccount1;`. That way you don't have to know what the internal IP address is within the docker compose environment. 


## Run docker compose with azurite
(also supply required env vars for run_job.R with .Renviron file locally. Inside the docker-compose file I refer to the file)
`docker-compose  up`

It takes a few seconds for the storage container to start until it is ready the other container sprays some errors. Wait for 10 seconds or so and it starts to run normally. On azure itself the storage is
always available and superfast so it should just work there.

Stop the process with `ctrl+c` 

## pushing container to registry
(I'm using docker hub here, but you could use your own registry at azure)

`docker push rmhogervorst/azuretimertweet:v0.0.1`

## creating all the resources
see azure main readme.

I changed the timer settings back to once every day and recreated the the 
docker image and pushed the docker image again to the registry.
Because I have created a webhook inside docker hub it automatically updates
the serverless function when there is a new version of the image.


