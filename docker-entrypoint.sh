#!/usr/bin/env bash

WORKERS=${WORKERS:-4}
BIND_ADDRESS=${BIND_ADDRESS:-0.0.0.0}

if [ "x${PROJECT_NAME}" == "x" ]; then
  echo "PROJECT_NAME env variable not set, exiting..."
  exit 1
fi

GUNICORN=$(which gunicorn)
if [ ! -f ${GUNICORN} ]; then
  echo "gunicorn not found, exiting..."
  exit 1
fi

set -e
RUN_DJANGO_MIGRATE=${RUN_DJANGO_MIGRATE:-yes}
if [ "${RUN_DJANGO_MIGRATE}" == "yes" ]; then
  echo "Running migrate..."
  python manage.py migrate --no-input
fi

RUN_DJANGO_COLLECTSTATIC=${RUN_DJANGO_COLLECTSTATIC:-yes}
if [ "${RUN_DJANGO_COLLECTSTATIC}" == "yes" ]; then
  echo "Running collectstatic..."
  python manage.py collectstatic --no-input
fi
set +e


${GUNICORN} --bind ${BIND_ADDRESS} \
            --workers ${WORKERS} \
            $GUNICORN_CONF \
            "${PROJECT_NAME}.wsgi"


