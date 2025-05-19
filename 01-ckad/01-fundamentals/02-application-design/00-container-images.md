# Container Images

## Some main concepts

Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. Originally developed by Google, it is now maintained by the Cloud Native Computing Foundation (CNCF).

A container image is a static, read-only file that contains the application code, runtime, libraries, environment variables, and configuration files needed to run a container. It’s like a blueprint or template.

A container is a runtime instance of a container image. It’s what you get when you run an image. The container uses the image as a base and adds a writable layer on top where changes happen during execution.

> So: Image = Blueprint, Container = Running Instance.

## Working with container images

List images:

```bash
docker images
# Or use podman
podman images
```

Pulling images. A container image has format `<image_name>:<tag>`:

```bash
docker pull nginx:1.25.0
# Or use podman
podman pull nginx:1.25.0
```

Saving image in the filesystem:

```bash
docker save nginx:1.25.0 > nginx-image.tar
podman save nginx:1.25.0 > nginx-image.tar
# Using using flag -o
docker save nginx:1.25.0 -o nginx-image.tar
podman save nginx:1.25.0 -o nginx-image.tar
```

Deleting images locally:

```bash
docker rmi nginx:1.25.0
# Or use podman
podman rmi nginx:1.25.0
```

Loading image in the local registry:

```bash
docker load < nginx-image.tar
podman load < nginx-image.tar
# Using flag -i
docker load -i nginx-image.tar
podman load -i nginx-image.tar
```

Anatomy of a `Dockerfile`:

| **Directive** | **Description**                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------- |
| `FROM`        | Specifies the base image to build upon.                                                           |
| `LABEL`       | Adds metadata to the image as key-value pairs.                                                    |
| `ENV`         | Sets environment variables in the image as key-value pairs.                                       |
| `RUN`         | Executes commands in the image during build time.                                                 |
| `CMD`         | Provides the default command to run when a container is started.                                  |
| `ENTRYPOINT`  | Configures a container to run as an executable. If set then `CMD` acts as `ENTRYPOINT` arguments. |
| `COPY`        | Copies files or directories from the host into the image.                                         |
| `ADD`         | Like `COPY`, but also supports remote URLs and automatic unpacking of archives.                   |
| `WORKDIR`     | Sets the working directory for subsequent instructions.                                           |
| `EXPOSE`      | Indicates the port on which the container listens (informational only).                           |
| `USER`        | Specifies the user to use when running commands inside the container.                             |
| `ARG`         | Defines variables that users can pass at build time (`docker build --build-arg`).                 |

Building an image. Take as source `99-examples/00-container-images/demo-app`. Build the image passing a name, a tag and the build context.

```bash
cd 99-examples/00-container-images/demo-app
docker build -t my-app:1.0.0 .
podman build -t my-app:1.0.0 .
```

Check images

```bash
docker images
podman images
```

## Working with containers

Basic container run. Next command will run the container and attach the terminal to it. Container logs will be displayed.

```bash
docker run nginx:1.25.0
```

You can stop the container using `Ctrl+c`. The container stopped is visible using:

```bash
docker ps -a
```

> `-a` flags displays running and stopped containers

Remove a stopped container. Use the container id or name from `docker ps -a`.

```bash
docker rm c308e176f86c
podman rm c308e176f86c
```

Run a container with a name, detached mode and expose port `80` locally on host port `8080`:

```bash
docker run --name webserver -d -p 8080:80 nginx:1.25.0
podman run --name webserver -d -p 8080:80 nginx:1.25.0
curl http://localhost:8080
```

Execute an interactive shell in a running container:

```bash
docker exec -it webserver sh
podman exec -it webserver sh
```

Run a temporary container. The container will be removed when command finishes:

```bash
docker run --rm busybox:1.37.0 env
podman run --rm busybox:1.37.0 env
```

Run a temporary container in interactive mode.

```bash
docker run --rm -it busybox:1.37.0 sh
podman run --rm -it busybox:1.37.0 sh
```

Stop and remove the container:

```bash
docker stop webserver
docker rm webserver
podman stop webserver
podman rm webserver
```

Run an container using our previously built image exposing port `3000`

```bash
docker run --name my-app -d -p 3000:3000 my-app:1.0.0
podman run --name my-app -d -p 3000:3000 my-app:1.0.0
curl http://localhost:3000 # Hello world
```
