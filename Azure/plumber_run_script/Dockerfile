# To enable ssh & remote debugging on app service change the base image to the one below
#FROM mcr.microsoft.com/azure-functions/base:3.0-appservice
FROM mcr.microsoft.com/azure-functions/base:3.0-appservice
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true
### needed a higher version of R, defaulted to 3.5
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
RUN echo "deb http://cloud.r-project.org/bin/linux/debian buster-cran40/" > /etc/apt/sources.list.d/backports.list
RUN apt-get update && \
    apt-get install -y  -t buster-cran40 r-base
RUN apt-get install -y --no-install-recommends \
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
COPY run_job.R /home/site/wwwroot/run_job.R
