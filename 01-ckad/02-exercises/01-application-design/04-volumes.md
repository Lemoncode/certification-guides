# Volume Exercises

## Exercise 1.

Create a Pod YAML manifest with two containers that use the image `alpine:3.20`. 
Keep the containers running forever. 

Define a Volume of type `emptyDir` for the Pod. Container 1 should mount the Volume to path */opt/1*, and container 2 should mount the Volume to path */opt/2*.

Open an interactive shell for container 1 and create the directory *data* in the mount path. Navigate to the directory and create the file *elvis.txt* with the contents “elvis has left the building.” Exit out of the container.

Open an interactive shell for container 2 and navigate to the directory */opt/2/data*. Inspect the contents of file *elvis.txt*. Exit out of the container.

## Exercise 2.

Create a *PersistentVolume* named `my-logs-pv` that maps to the `hostPath` */var/logs*. The access mode should be `ReadWriteOnce` and `ReadOnlyMany`. Provision a storage capacity of 3Gi. Ensure that the status of the *PersistentVolume* shows `Available`.

Create a *PersistentVolumeClaim* named `my-logs-pvc`. The access it uses is `ReadWriteOnce`. Request a capacity of 2Gi. Ensure that the status of the *PersistentVolume* shows `Bound`.

Mount the *PersistentVolumeClaim* in a Pod running the image `alpine:3.20` at the mount path */var/log/alpine*.

Open an interactive shell to the container and create a new file named *my-logs.log* in */var/log/alpine*. Exit out of the Pod.

Delete the Pod and re-create it with the same YAML manifest. Open an interactive shell to the Pod, navigate to the directory */var/log/alpine*, and find the file you created before.