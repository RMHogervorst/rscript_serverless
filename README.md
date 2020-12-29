### Serverless for R

My attempts to run serverless functions on cloud providers.
Serverless is a misleading name, there are servers, but we don't care about them
at all. Serverless promisses to allow you to run a your function and only pay
for execution time.

On the three major cloud providers they are called

* [Amazon] : *AWS* Lambda
* [Microsoft](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?pivots=programming-language-other&tabs=bash%2Cportal&WT.mc_id=aiml-11825-davidsmi) : *Azure* Functions
* [Google] : *GCP*  Cloud functions


Usually only the largest languages are supported: Javascript (Node), Python, Java, Go, PowerShell, C#, Ruby 

* AWS: Javascript (Node), Python, Java, Go, PowerShell, C#, Ruby , and custom
* Azure: .NET core (C#), Javascript (node), F#, Java, PowerShell, Typescript, Python, and in preview (so not ready for production yet: Custom handlers)

* GCP: Node, Python, Go, Java, .NET






### Resources

#### AWS 
* [Main AWS page about Lambda](https://aws.amazon.com/lambda/)
* [An r-bloggers post in 2019 about running R on AWS lambda](https://www.r-bloggers.com/2019/07/how-to-use-r-in-aws-lambda/ "original lost in time")
* [AWS runtime created by Appsilon](https://github.com/Appsilon/r-lambda-workflow)
