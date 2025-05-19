# Deployment Exercises

## Exercise 1.

Create a Deployment named `my-nginx` with 4 replicas. The Pods should use the `nginx:1.27.0` image and the name `my-nginx`. The Deployment uses the label `apps=backend`. The Pod template should use the label `app=v0`.

List the Deployment and ensure that the correct number of replicas is running.

Update the image to `nginx:1.27.3`.

Verify that the change has been rolled out to all replicas.

Assign the change cause “Forward patch version” to the revision.

Scale the Deployment to 6 replicas.

Have a look at the Deployment rollout history. Revert the Deployment to revision 1.

Ensure that the Pods use the image `nginx:1.27.0`.

## Exercise 2.

Create a Deployment named nginx with 1 replica. The Pod template of the Deployment should use container image `nginx:1.27.2`, set the CPU resource request to 0.5, and the memory resource request/limit to 500Mi.

Create a *HorizontalPodAutoscaler* for the Deployment named `nginx-hpa` that scales to minium of 4 and a maximum of 8 replicas. Scaling should happen based on an average CPU utilization of 70%, and an average memory utilization of 50%.

Inspect the *HorizontalPodAutoscaler* object and identify the currently-utilized resources. How many replicas do you expect to exist?