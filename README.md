# friendos-mysql-docker
Docker image for Friend OS database

## Building

docker build -t friendos-mysql-docker ./

## Run the Docker

```bash
docker run -d -p 3306:3306 --name friendos-docker-container friendos-mysql-docker
```

## If you want to enter the docker container

```bash
docker exec -it friendos-mysql-docker-container bash
```

## If you want to re-build the image for some reason, do this:

```bash
docker rmi friendos-mysql-docker
```

