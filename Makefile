build:
	docker pull adoptopenjdk/openjdk11:debian
	source ./version && docker build -t eugenmayer/rundeck:"$${VERSION}" --build-arg RUNDECK_VERSION="$${VERSION}" . 

push:
	source ./version && docker push eugenmayer/rundeck:"$${VERSION}"
