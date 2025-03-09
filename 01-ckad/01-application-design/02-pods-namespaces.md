# Pods and namespaces exercises

## Exercise 1

Create a new Pod named `my-server` running the image `nginx:1.27.2`. Expose the container port 80. The Pod should live in the namespace named `lemoncode`.

Get the details of the Pod including its IP address.

Create a temporary Pod that uses the `busybox:1.37.0` image to execute a `wget` command inside of the container. The `wget` command should access the endpoint exposed by the `my-server` container. What is the response that you get? 

Get the logs of the `my-server` container.

Add the environment variables `DB_URL=mysql://adminr@mysql:3306` and `DB_PASSWD=foo` to the container of the `nginx` Pod.

Open a shell for the `my-server` container and inspect the contents of the current directory `ls -l`. Exit out of the container.

## Exercise 2

Create a YAML manifest for a Pod named `greeting` that runs the `busybox:1.37.0` image in a container. The container should run the following command: `for i in {1..5}; do echo "Hello $i world"; done`. Create the Pod from the YAML manifest. What’s the status of the Pod?

Edit the Pod named `greeting`. Change the command to run in an endless loop. Each iteration should `echo` the current date.

Inspect the events and the status of the Pod `greeting`.