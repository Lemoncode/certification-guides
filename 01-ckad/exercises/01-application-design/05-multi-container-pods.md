# Multi-Container Exercises

## Exercise 1.

Create a YAML manifest for a Pod named `multi-pod`. The main application container named `app` should use the image `nginx:1.27.0` and expose the container port 80. Modify the YAML manifest so that the Pod defines an init container named `setup`, that uses the image `busybox:1.37.0`. The init container runs the command `wget -O- lemoncode.net`.

Use a YAML manifest to create the Pod.

Retrieve the logs of the init container.

> Check solution by downloading the logs of the init container. You should see the output of the `wget` command.

Open an interactive shell to the main application container and run the `ls` command. Exit out of the container.

Remove the Pod.

## Exercise 2.

Create a YAML manifest for a Pod named `my-exchange`. The main application container named `my-app` should use the image `busybox:1.37.0`. The container runs a command that writes a new file every 45 seconds in an infinite loop in the directory */tmp/my-app/data*. The filename follows the pattern *{index++}-data.txt*. The variable index is incremented every interval and starts with the value 0.

Modify the YAML manifest by adding a sidecar container named `sidecar`. The sidecar container uses the image `busybox:1.37.0` and runs a command that counts the number of files produced by the `my-app` container every 90 seconds in an infinite loop. The command writes the number of files to standard output.

Define a Volume of type `emptyDir`. Mount the path */tmp/my-app/data* for both containers.

Create the Pod. Tail the logs of the sidecar container.

Delete the Pod.