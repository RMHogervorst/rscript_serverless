# To enable ssh & remote debugging on app service change the base image to the one below
#FROM mcr.microsoft.com/azure-functions/base:3.0-appservice
FROM mcr.microsoft.com/azure-functions/dotnet:3.0-appservice
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

RUN apt update && \
    apt install -y  r-base
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libsodium-dev \
    git-core \
    libssl-dev libxt6 && \
    mkdir -p ~/.local/share/renv && \
    R -e "install.packages('renv', repos='http://cran.rstudio.com/')"
### splitted the copying into parts so the rebuiliding times are quicker
COPY renv.lock /home/site/wwwroot/renv.lock
WORKDIR /home/site/wwwroot
RUN R -e "renv::restore(prompt=FALSE)"
COPY CRONtrigger/ /home/site/wwwroot/CRONtrigger
COPY host.json /home/site/wwwroot/host.json
COPY handler.R /home/site/wwwroot/handler.R
COPY handle-this.R /home/site/wwwroot/handle-this.R
