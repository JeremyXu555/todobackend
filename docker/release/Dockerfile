FROM jeremyxu666/ci-docker-ansible-base
#
#RUN apt-get update && \
#    apt-get install -qy python3-dev libmysqlclient-dev python-pip

# Copy application artifacts
COPY target /wheelhouse

# Install application
RUN . /appenv/bin/activate && \
    pip install --no-index -f /wheelhouse todobackend && \
    rm -rf /wheelhouse