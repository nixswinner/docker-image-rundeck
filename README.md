rundeck
==============

Docker: Docker image [eugenmayer/rundeck](https://hub.docker.com/r/eugenmayer/rundeck/) for running [rundeck](http://rundeck.org)

Rancher: Also see the corresponding [rancher-catalog](https://github.com/EugenMayer/docker-rancher-extra-catalogs) if you run [rancher](https://rancher.com/)

# Usage

```
docker-compose up
```

(replace localhost with your `docker-machine ip` if you use `dockertoolbox` or similar)
You can now access the instance by going on `https://localhost`
If you set an `EXTERNAL_SERVER_URL` with an `http` scheme in the [.env](https://github.com/EugenMayer/rundeck/blob/master/.env) file, you need to use `http://localhost`

Username is `admin` - password is `rundeck`
## Configuration / Adjustments 

Just edit [.env](https://github.com/EugenMayer/rundeck/blob/master/.env) and adjust it to what you need

Advanced: You can mount custom scripts into the container at `/docker-entrypoint.d/` to let them 
run every single container start. So `-v mysqcript.sh:/docker-entrypoint.d/myscript.sh`

# Image details

1. Rundeck with a (replaceable) postgresql database as sideload
1. No SSH.  Use docker exec
1. You must supply the EXTERNAL_SERVER_URL parameter
1. As always, update passwords for pre-installed accounts
1. I sometimes get connection reset by peer errors when building the Docker image from the Rundeck download URL.  Trying again usually works.

# Volumes

In order of importance

```
/etc/rundeck - rundeck configuration
/var/rundeck - rundecks project folder
/var/lib/rundeck/logs - the logs and states of your jobs - pretty important!!!
/var/lib/rundeck/var/storage - file based storage folder
/opt/rundeck-plugins - For adding external plugins
/var/log/rundeck - general daemon logs
```

# Advanced configuration

## Mysql as your backend

If you want to run against a mysql, change `DB_TYPE=mysql` and include a mysql service like MariaDB or Percona

## Rundeck plugins
To add (external) plugins, add the jars to the /opt/rundeck-plugins volume and they will be copied over to Rundeck's libext directory at container startup

## Docker secrets
Reference: https://docs.docker.com/engine/swarm/secrets/
The entrypoint run script will check for docker secrets set for RUNDECK_PASSWORD, DATABASE_ADMIN_PASSWORD, KEYSTORE_PASS, and TRUSTSTORE_PASS.  If the secret has not been set, it will then check for the environment variable and finally default to generating a random value.

# Environment variables

Please see the [.env](https://github.com/EugenMayer/rundeck/blob/master/.env) file

# Using an SSL Terminated Proxy
See the docker-compose.yml `rundeckhttpd` - that is how you usually would do a SSL termination proxy, nothing in addition is needed.
If you would not enable ACME in traefik, SSL would work.
Also See: http://rundeck.org/docs/administration/configuring-ssl.html#using-an-ssl-terminated-proxy

# Upgrading
See: http://rundeck.org/docs/upgrading/index.html

## Upgrading image

- adjust `version` to the new version rundeck released
- run `make build`

# Nginx
A helper to fix the missing OPTIONS calls in rundeck and allowing CORS 


# Build yourself

```shell
make build

# or

docker build . -t yourown
```