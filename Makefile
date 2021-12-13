build:
	docker pull bellsoft/liberica-openjre-debian:11
	source ./version && DOCKER_BUILDKIT=0 docker build -t eugenmayer/rundeck:"$${VERSION}" --build-arg RUNDECK_VERSION="$${VERSION}" . 

push:
	source ./version && docker push eugenmayer/rundeck:"$${VERSION}"
