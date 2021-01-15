# Minimal example of R script responding to timer trigger

Timer trigger needs azure storage and so I also need to run the azurite container
that simulates azure storage and tell the function where to find it.


`docker run -p 10000:10000  mcr.microsoft.com/azure-storage/azurite`
