# Exercise 1

Using your favourite image builder (docker, podman) go to `resources/01-container-images/app1` and perform next operations:

- Build the image under name `go-web` with tag `1.0.0`.
- Run the container and expose port `8080` to the host. Does the container run properly?
- After working with development team they missed the environment variable `CGO_ENABLED=0` before building. You need to edit `Dockerfile` manifest to add it to the `builder` stage before application is built.
- Create a new image with the updated `Dockerfile` under the name `go-web:1.0.1`.
- Recreate the container using the new image `go-web:1.0.1`. Does the container work?
- In another terminal try to use `curl` to perform a request to the container on port `8080` and endpoint `/hello`. What does the server respond?
- Create a `backup` folder and save the image contents there as a tar file under the name `backup/go_web_1_0_1.tar`.
