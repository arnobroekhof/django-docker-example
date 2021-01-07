#!/usr/bin/env bash

WORKERS=${WORKERS:-4}
BIND_ADDRESS=${BIND_ADDRESS:-0.0.0.0}
BIND_PORT=${BIND_PORT:-8000}

if [ "x${PROJECT_NAME}" == "x" ]; then
  echo "PROJECT_NAME env variable not set, exiting..."
  exit 1
fi

GUNICORN=$(which gunicorn)
if [ "x${GUNICORN}" == "x" ]; then
  echo "gunicorn not found, exiting..."
  exit 1
fi

RUN_DJANGO_MIGRATE=${RUN_DJANGO_MIGRATE:-yes}
if [ "${RUN_DJANGO_MIGRATE}" == "yes" ]; then
  echo "Running migrate..."
  if ! python manage.py migrate --no-input; then
    echo "Error running migrate, exiting..."
    exit 1
  fi
fi

RUN_DJANGO_COLLECTSTATIC=${RUN_DJANGO_COLLECTSTATIC:-yes}
if [ "${RUN_DJANGO_COLLECTSTATIC}" == "yes" ]; then
  echo "Running collectstatic..."
  if ! python manage.py collectstatic --no-input; then
    echo "Error collecting static files, exiting..."
    exit 1
  fi
fi

CMD="gunicorn --bind ${BIND_ADDRESS}:${BIND_PORT} --workers ${WORKERS} ${GUNICORN_CONF} ${PROJECT_NAME}.wsgi"

exec ${CMD}


