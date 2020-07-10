build:
	#docker pull debian:buster
	docker pull debian:stretch
	source ./version && docker build -t eugenmayer/rundeck:"$${VERSION}" --build-arg RUNDECK_VERSION="$${VERSION}" . 

push:
	source ./version && docker push eugenmayer/rundeck:"$${VERSION}"
