# Django Docker example

![Docker Build Status](https://img.shields.io/docker/build/arnobroekhof/django-docker-example) ![Docker Automated build](https://img.shields.io/docker/automated/arnobroekhof/django-docker-example)

example of running a Django Application inside a Docker container

## Directory layout

```
├── Dockerfile            --> docker build file
├── LICENSE               --> LICENSE file
├── .dockerignore         --> file that must be ignored by the docker build process
├── .editorconfig         --> editor config file for formatting
├── .gitignore            --> file that need to be ignored by git
├── Makefile              --> GNU Make file for automating commands
├── README.md             --> this file
├── docker-entrypoint.sh  --> docker entrypoint script
├── example               --> Django root project
│ ├── __init__.py         --> Django package init file
│ ├── asgi.py             --> Asynchronous Server Gateway Interface file
│ ├── settings.py         --> Django settings file
│ ├── urls.py             --> Django urls file
│ └── wsgi.py             --> Web Server Gateway Interface file
├── manage.py             --> Django Manage file
├── requirements.txt      --> Python pip dependencies file 
└── static                --> Django static files directory
```

## Available Configuration settings

| Name | Default value | Required for startup | Description |
|:----:|:-------------:|:------------:|:--------|
| PROJECT_NAME |<empty>| yes| the name of the django project ( directory where the wsgi file is located ) |
|BIND_PORT|8080|no |the default port to run on|
|BIND_ADDRESS|0.0.0.0|no |the default address to run on|
|WORKERS|4|no | the worker threads to spawn for running the application|
|DATABASE_ENGINE|django.db.backends.sqlite3|no |the database engine to use|
|DATABASE_NAME|db.slite3|no |the database name to use, this is the full path to the file|
|DATABASE_USER|<empty>|no | the username for the database|
|DATABASE_PASSWORD|<empty>|no | the password for the database |
|DATABASE_HOST|<empty>|no | the address of the database |
|DATABASE_PORT|<empty>|no | the port that the database uses |
|RUN_DJANGO_MIGRATE | yes |no | yes or no the run migrate before startup |
|RUN_DJANGO_COLLECTSTATIC | yes |no | yes or no to run collect static before startup |
|GUNICORN_CONF| <empty> |no | additional gunicorn parameters |

## Dev Requirements

* Linux or MacOS
* Python 3.7.9 or higher
* Make
* Python virtualenv

### create dev environment

```
make dev/deps
```

# Container building

build plain

```
make image/build
```

test plain build and run

```
make image/test
```

build and push to custom repo

```
export IMAGE_REPO="somerepo-uri"
docker login $IMAGE_REPO
make image/push
```

# use this in your own project

copy the following files to your project root directory

* Makefile
* Dockerfile
* docker-entrypoint.sh

## adjust the Makefile with your own settings

```makefile
IMAGE_REPO?="<name-of-your-docker-repository>"
PROJECT_NAME?="<the name of the directory where the wsgi file is located>"
```

## alter settings.py

### Database config
```python
import os
DATABASES = {
    'default': {
        'ENGINE': os.getenv("DATABASE_ENGINE", default='django.db.backends.sqlite3'),
        'NAME': os.getenv("DATABASE_NAME", default=BASE_DIR / 'db.sqlite3'),
        'USER': os.getenv("DATABASE_USER"),
        'PASSWORD': os.getenv("DATABASE_PASSWORD"),
        'HOST': os.getenv("DATABASE_HOST"),
        'PORT': os.getenv("DATABASE_PORT"),
    }
}
```

### Static root
```python
STATIC_ROOT = 'static'
```

now test everything by running the command

```
make image/test
```

if everything goes wel your Django Application will be available at [http://localhost:8000](http://localhost:8000)
