rundeck
==============

Docker image [eugenmayer/rundeck](https://hub.docker.com/r/eugenmayer/rundeck/) for running [rundeck](http://rundeck.org)


# Usage

```
docker-compose up
```

(replace localhost with your `docker-machine ip` if you use `dockertoolbox` or similar)
You can now access the instance by going on `https://localhost`
If you set `RUNDECK_WITH_SSL=false` in the `.env` file, you need to use `http://localhost`

## Configuration / Adjustments 

Just edit `.env` and adjust it to what you need

Advanced: You can mount custom scripts into the container at `/docker-entrypoint.d/` to let them 
run every single container start. So `-v mysqcript.sh:/docker-entrypoint.d/myscript.sh`

# Image details

1. Rundeck with a (replaceable) postgresql database as sideload
1. No SSH.  Use docker exec
1. Supply the EXTERNAL_SERVER_URL or it will default to https://0.0.0.0:4443
1. As always, update passwords for pre-installed accounts
1. I sometimes get connection reset by peer errors when building the Docker image from the Rundeck download URL.  Trying again usually works.


# Advanced configuration

## Mysql as your backend

If you want to run against a mysql, change `DB_TYPE=mysql` and include a mysql service like MariaDB or Percona

## Rundeck plugins
To add (external) plugins, add the jars to the /opt/rundeck-plugins volume and they will be copied over to Rundeck's libext directory at container startup

## Docker secrets
Reference: https://docs.docker.com/engine/swarm/secrets/
The entrypoint run script will check for docker secrets set for RUNDECK_PASSWORD, DATABASE_ADMIN_PASSWORD, KEYSTORE_PASS, and TRUSTSTORE_PASS.  If the secret has not been set, it will then check for the environment variable and finally default to generating a random value.

# Environment variables

Please see the [.env]() file

# Volumes

```
/etc/rundeck - rundesk configuration
/var/rundeck
/var/lib/rundeck - Not recommended to use as a volume as it contains webapp.  For SSH key you can use the this volume: /var/lib/rundeck/.ssh
/opt/rundeck-plugins - For adding external plugins
/var/log/rundeck - logs
/var/lib/rundeck/logs
/var/lib/rundeck/var/storage - file based storage folder
```

# Working behind a web proxy
If you are running Rundeck behind a web proxy, use the following:
```
sudo docker run -p 4440:4440 \
  -e EXTERNAL_SERVER_URL=http://MY.HOSTNAME.COM:4440 \
  -e HTTP_PROXY="http://WEBPROXY:PORT" \
  -e HTTPS_PROXY="http://WEBPROXY:PORT" \
  -e RDECK_JVM="-Djava.net.useSystemProxies=true" \
  --name rundeck -t eugenmayer/rundeck:latest
```


# Using an SSL Terminated Proxy
See: http://rundeck.org/docs/administration/configuring-ssl.html#using-an-ssl-terminated-proxy

# Upgrading
See: http://rundeck.org/docs/upgrading/index.html
