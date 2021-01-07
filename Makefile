GIT_COMMIT=$$(git rev-parse --short HEAD)
IMAGE_REPO?="arnobroekhof"

.PHONY: image/build
image/build:
	DOCKER_BUILDKIT=1 docker build -t $(IMAGE_REPO)/django-docker-example:$(GIT_COMMIT) .

.PHONY: image/push
image/push: image/build
	docker push $(IMAGE_REPO)/django-docker-example:$(GIT_COMMIT)

.PHONY: image/test
image/test:	image/build
	docker run -e API_PORT=8080 -p 8080:8080 $(IMAGE_REPO)/django-docker-example:$(GIT_COMMIT)

.PHONY: dev/deps
dev/deps:
	python -m venv .venv
	. .venv/bin/activate
	pip install -r requirements.txt

.PHONY: dev/deps-freeze
dev/deps-freeze:
	pip freeze > requirements.txt

.PHONY: dev/migrate
dev/migrate:
	. .venv/bin/activate
	@python manage.py migrate
