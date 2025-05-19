# Exercise Container Probes

## Exercise 1.

Define a new Pod named `my-server` with the image `nginx:1.27.0` in a YAML manifest.  Don't create the Pod, just the manifest (we are going to modify it).

> Use the default configuration for all the following probes.

For the container, declare a startup probe of type `httpGet`. Verify that the kubelet can make a request to the default nginx root page. 

For the container, declare a readiness probe of type `httpGet`. Verify that the kubelet can make a request to the default nginx root page. Wait three seconds before checking for the first time.

For the container, declare a liveness probe of type `httpGet`. Verify that the kubelet can make a request to the default nginx root page. Wait 7 seconds before checking for the first time. The probe should run the check every 30 seconds.

Create the Pod and follow the lifecycle phases of the Pod during the process.

Locate and dump the runtime details of the Pod’s probes into a file called `probes`.