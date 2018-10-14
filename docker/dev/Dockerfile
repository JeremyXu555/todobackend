FROM jeremyxu666/ci-docker-ansible-base

# Install dev/build dependencies
RUN apt-get update && \
    apt-get install -qy python3-dev libmysqlclient-dev \
             libssl-dev libffi-dev \
             libxml2-dev libxslt1-dev zlib1g-dev

# Activate virtual environment and install wheel support
RUN . /appenv/bin/activate && \
    pip install wheel --upgrade

# Wheel is a built-package format for Python. A wheel is a ZIP-format archive with a specially formatted file name and
# .whl extension

# PIP environment variables (NOTE: must be set after installing wheel)
ENV WHEELHOUSE=/wheelhouse PIP_WHEEL_DIR=/wheelhouse PIP_FIND_LINKS=/wheelhouse XDG_CACHE_HOME=/cache

# OUTPUT: Build artefacts (Wheels) are output here
VOLUME /wheelhouse

# OUTPUT: Build cache: in this way the other container will have access to this folder like an expose folder
VOLUME /build

# OUTPUT: Test reports are output here
VOLUME /reports

# Add test entrypoint script
COPY scripts/test.sh /usr/local/bin/test.sh
RUN chmod +x /usr/local/bin/test.sh

# Set defaults for entrypoint and command string
ENTRYPOINT ["test.sh"]
CMD ["python", "manage.py", "test", "--noinput"]

# Add application source
COPY src /application
WORKDIR /application
