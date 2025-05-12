ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE 

WORKDIR /irisdev/app

## Python stuff
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "IRISAPP"

ENV PYTHON_PATH=/usr/irissys/bin/
ENV LD_LIBRARY_PATH=${ISC_PACKAGE_INSTALLDIR}/bin:${LD_LIBRARY_PATH}

ENV PATH "/home/irisowner/.local/bin:/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

COPY . .
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} iris-python /usr/irissys/mgr/python

RUN pip3 install -r requirements.txt && \
    echo 'from langchain.embeddings import FastEmbedEmbeddings; FastEmbedEmbeddings()' | python3

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /irisdev/app/iris.script \
    && iris stop IRIS quietly
