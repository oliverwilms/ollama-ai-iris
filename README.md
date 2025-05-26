# Ollama AI IRIS

## My first AI use case

In order to automate processing medical PDF documents I want to employ AI to identify information such as Patient, Provider and Chief Complaint. I have developed this [prompt](https://github.com/oliverwilms/ollama-ai-iris/blob/main/data/prompts/medical_progress_notes_prompt.txt) to instruct AI what I am looking for.

## How can I get AI to process my request?

I looked at this [API](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-chat-completion) and created an Interoperability production with a Generic REST interface to capture requests and responses:
![screenshot](https://github.com/oliverwilms/bilder/blob/main/Oliver_NewProduction.JPG)
Below are examples of a request: ![request](https://github.com/oliverwilms/bilder/blob/main/Capture_request.JPG) and the corresponding response from ollama: ![response](https://github.com/oliverwilms/bilder/blob/main/Capture_response.JPG)

It was not what I expected.

## What is in ollama-ai-iris?

I have downloaded PDF Medical Visit Summaries from my Doctor's patient portal.

![screenshot](https://github.com/oliverwilms/bilder/blob/main/visitSummary.JPG)

I already mentioned that I created an Interoperability [Production](https://github.com/oliverwilms/ollama-ai-iris/blob/main/src/Oliver/NewProduction.cls). First I created a generic REST interface so that I could trace requests and responses going to ollama. Later I added a File Service to pick up PDF files and created a BPL to extract text from the PDF files. I sent the text as a StreamContainer to a File Passthrough operation.

![MessageTrace1](https://github.com/oliverwilms/bilder/blob/main/CapturePdfExtractText.JPG)

Then I created another File Service to pick up the text files, and I created another BPL where I call an IRIS ObjectScript classmethod to invoke SendChat() to ollama. Here I employ a persistent class to measure response times and keep track of the responses coming back from ollama. To make the response from ollama visible in message traces, I send the response as a StreamContainer to the File Passthrough operation.

![MessageTrace2](https://github.com/oliverwilms/bilder/blob/main/CaptureSendChatResp.JPG)

When the Production is running, it picks up any *.pdf file in /irisdev/app/data_example/ directory. This directory is mapped to the data_example directory where you cloned the git repository. Any pdf file you copy into the data_example directory in the git directory or /irisdev/app/data_example/ inside the iris container will process in the production.



To open IRIS Terminal do:

```
$ docker-compose exec iris iris session iris -U IRISAPP
IRISAPP>
```

To exit the terminal, do any of the following:

```
Enter h, halt, HALT or H (not case-sensitive)
```

## Requirements

0\. I implemented ollama-ai-iris as a containerized app. If you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed, see Installation: Docker below.

1\. Ollama installed and running on your computer (you can download it from https://ollama.com/download). You can test if it's ok running the following command on prompt: `ollama run llama3.2 "Explain the basics of machine learning."`

2\. Python 3.12 or above

3\. Install the following python packages using the `pip install` command:
```
llama-index
llama-index.embeddings.huggingface
llama-index.llms.ollama
sqlalchemy-iris
```

4\. Intersystems IRIS 2024.1 or above

## Installation: Docker

Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/ollama-ai-iris.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```





## Credits

This repo got started when I forked [https://github.com/RodolfoPscheidtJr/ollama-ai-iris](https://github.com/RodolfoPscheidtJr/ollama-ai-iris). I had been trying to implement OpenAI use case, but I really liked that this repo uses ollama deployment in place of calling OpenAI.

Ollama is an open source tool that runs large language models (LLMs) directly on a computer. The advantage of Ollama is that it runs locally, which brings more security, and does not depend on a paid subscription, as OpenAI requires.

Thanks to [llama-iris](https://openexchange.intersystems.com/package/llama-iris) library by @Dmitry Maslennikov and to [iris-vector-search](https://openexchange.intersystems.com/package/iris-vector-search) by @Alvin Ryanputra 

I had seen in [Guillaume Rongier's](https://github.com/grongierisc) Open Exchange app [iris-rag-demo](https://openexchange.intersystems.com/package/iris-rag-demo) how to deploy ollama container via [docker-compose.yml](https://github.com/grongierisc/iris-rag-demo/blob/master/docker-compose.yml).
