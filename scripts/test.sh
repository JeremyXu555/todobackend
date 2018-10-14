#!/bin/bash
# Activate virtual environment
. /appenv/bin/activate

# Download the requirements dependencies to the build cache, -d: is the destination
pip download --dest /build -r requirements-test.txt --no-input

# Install application test requirements: --no-index: make sure the pip will not download any packages externally
# -f: find flag
pip install --no-index -f /build -r requirements-test.txt

# Run test.sh arguments
exec $@
