FROM python:3.9-alpine3.13
LABEL maintainer=""

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apk add --no-cache gcc musl-dev python3-dev && \ 
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home djangouser && \
    chown -R djangouser:djangouser /app

ENV PATH="/py/bin:$PATH"

USER djangouser

CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000"]