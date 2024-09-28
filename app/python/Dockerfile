# ARG PYTHON_VERSION=3.11.5
# FROM python:${PYTHON_VERSION}-slim as base

# WORKDIR /app

# COPY . .

# # Install dependencies
# RUN python -m pip install -r requirements.txt

# ENV APP_PORT=8080

# # Expose the port that the application listens on.
# EXPOSE ${APP_PORT}

# # Run the application.
# CMD python app.py


# Build a virtualenv using the appropriate Debian release
# * Install python3-venv for the built-in Python3 venv module (not installed by default)
# * Install gcc libpython3-dev to compile C Python modules
# * In the virtualenv: Update pip setuputils and wheel to support building new packages
# ARG PYTHON_VERSION=3.11.9
FROM debian:12-slim AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel && ls -al /venv/bin && \
    ln -sf /usr/bin/python3 /venv/bin/python3

# Build the virtualenv as a separate step: Only re-execute this step when requirements.txt changes
FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian12
COPY --from=build-venv /venv /venv
COPY app.py /app/app.py
WORKDIR /app
ENTRYPOINT ["/venv/bin/python3", "app.py"]
