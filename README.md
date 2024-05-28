# friendos-mysql-docker
Docker image for Friend OS database

The network (which must be created if it isn't)

## Building and running

docker-compose up --build

## If you want to enter the docker container

```bash
docker exec -it friendos-mysql-docker-container bash
```

## If you want to re-build the image for some reason, do this:

```bash
docker rmi friendos-mysql-docker
```

