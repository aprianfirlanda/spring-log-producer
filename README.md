# README

## Build

build to jar
```shell
./mvnw -DskipTests package
```

build to docker image
```shell
docker build -t aprianfirlanda/spring-log-producer:0.1.0 .
```

then push docker image to the docker registry
```shell
docker push aprianfirlanda/spring-log-producer:0.1.0
```

or you can use executable file
```shell
chmod +x build-and-push.sh
```

then run this command
```shell
./build-and-push.sh
```
