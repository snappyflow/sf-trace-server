FROM golang:1.14.7
MAINTAINER Nicolas Ruflin <ruflin@elastic.co>

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         netcat python3 python3-pip python3-venv && \
    apt-get clean

ENV PYTHON_ENV=/tmp/python-env

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools

# Setup work environment
ENV APM_SERVER_PATH /usr/share/apm-server

RUN mkdir -p $APM_SERVER_PATH
WORKDIR $APM_SERVER_PATH

COPY . $APM_SERVER_PATH

RUN make

#CMD ./apm-server -e -d "*"
ENTRYPOINT ["/usr/share/apm-server/apm-server", "-c", "/usr/share/apm-server/apm-server.yml"]

# Add healthcheck for docker/healthcheck metricset to check during testing
#HEALTHCHECK CMD exit 0
