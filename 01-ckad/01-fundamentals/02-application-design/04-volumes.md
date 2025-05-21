# Volumes

We can differentiate two types of volumes:

- Ephemeral Volumes exist during the lifetime of a pod. Useful when you want to share data between multiple containers within the pod.
- Persistent Volumes preserve data beyond the lifetime of the Pod. They are a good choice for applications that need to preserve state, such as databases.

Define volume mounts in a pod via:

- `.spec.volumes[]`
- `.spec.containers[].volumeMounts[]`

## Ephemeral Volumes

### Types of Ephemeral Volumes

| **Type**                       | **Description**                                                                                                   |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| emptyDir                       | Empty at Pod startup, with storage coming locally from the kubelet base directory (usually the root disk) or RAM  |
| configMap, downwardAPI, secret | Inject different kinds of Kubernetes data into a Pod                                                              |
| image                          | Allows mounting container image files or artifacts, directly to a Pod.                                            |
| CSI ephemeral volumes          | Similar to the previous volume kinds, but provided by special CSI drivers which specifically support this feature |
| generic ephemeral volumes      | Which can be provided by all storage drivers that also support persistent volumes                                 |

Create a pod definition and define an `emptyDir`.

```bash
kubectl run pod-with-volume --image=busybox:1.37.0 -o yaml --dry-run=client -- /bin/sh -c "" > pod-with-volume.yaml
```

```diff
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: null
    labels:
      run: pod-with-volume
    name: pod-with-volume
  spec:
+   volumes:
+     - name: working-dir
+       emptyDir: {}
    containers:
      - args:
          - /bin/sh
          - -c
-         - ""
+         - |
+           while true; do
+               sleep 30
+               if [ ! -f $APP_FILE ]; then
+                 echo "Creating new file and exiting"
+                 echo "New file contents" > $APP_FILE
+                 exit 1
+               else
+                 echo "File exists:"
+                 cat $APP_FILE
+               fi
+             done
        image: busybox:1.37.0
+       env:
+         - name: APP_FILE
+           value: /app/new-file.txt
        name: pod-with-volume
        resources: {}
+       volumeMounts:
+         - name: working-dir
+           mountPath: /app
    dnsPolicy: ClusterFirst
    restartPolicy: Always
  status: {}
```

```bash
kubectl apply -f pod-with-volume.yaml
kubectl logs pod-with-volume -f
```

This pod will create a new file and exit with error. This example demonstrate even container crashes and restarts the file persists until pod is deleted.

### Persistent Volumes

Persistent volumes have their own lifecycle outside a Pod. A persistent volume is created via `PersistentVolume` object using YAML definition. A pod can consume a PersistentVolume by using a PersistentVolumeClaim bound to a PersistentVolume.

A pod use a persistent volume by using a `PersistentVolumeClaim`. A `PersistentVolumeClaim` is a request for storage by a user that specifies size, access modes, and storage class. Kubernetes then matches this claim to a suitable PersistentVolume that meets the criteria. Once bound, the pod can use the volume to persist data across restarts or rescheduling.

There are two types of provisioning:

- Static Provisioning: Admins manually create PersistentVolumes before they can be claimed.
- Dynamic Provisioning: Kubernetes automatically creates PersistentVolumes based on a StorageClass when a PersistentVolumeClaim is requested.

A StorageClass defines the type of storage a cluster administrator offers. It allows dynamic provisioning of PersistentVolumes without requiring users to manually create them in advance. Each StorageClass defines the provisioner (such as AWS EBS, GCE PD, NFS, etc.), parameters related to the backend storage system (like performance or replication settings), and reclaim policies.

By specifying a storageClassName in the PVC, Kubernetes knows which type of storage to provision dynamically. If no storageClassName is provided, and a default storage class exists, it will be used automatically.

Defining a PersistentVolume `app-data.pv.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-data
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /app/data
```

```bash
kubectl apply -f app-data.pv.yaml
kubectl get pv
```

AccessMode can be configured to specify how volumes can be used:

| AccessMode              | Description                                                                              |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| ReadWriteOnce (RWO)     | The volume can be mounted as read-write by a single node at a time.                      |
| ReadOnlyMany (ROX)      | The volume can be mounted as read-only by multiple nodes simultaneously.                 |
| ReadWriteMany (RWX)     | The volume can be mounted as read-write by multiple nodes at the same time.              |
| ReadWriteOncePod (RWOP) | Similar to RWO, but restricted to a single pod, even if other pods are on the same node. |

The status is Available meaning the PersistentVolume can be bound to a claim. The PersistentVolume is formatted to be used as a file system. This value is not displayed unless you use `-o wide`.

```bash
kubectl get pv -o wide
```

| VolumeMode | Description                                                                                                                                                                 |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Filesystem | The default mode. The volume is mounted as a filesystem into the pod. The pod interacts with it using standard file and directory operations (e.g., reading/writing files). |
| Block      | The volume is exposed to the pod as a raw block device. The application in the pod must handle formatting or accessing the device directly (e.g., using /dev/sdX).          |

ReclaimPolicy can be configured to specify what happens with data after the PersistentVolumeClaim is deleted.

| ReclaimPolicy | Description                                                                                                                                                                                        |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Retain        | The PersistentVolume (PV) is not deleted when the corresponding PersistentVolumeClaim (PVC) is deleted. Manual intervention is required to reuse or delete the volume. Useful for preserving data. |
| Delete        | The PV and its underlying storage resource are automatically deleted when the PVC is deleted. Common in dynamic provisioning scenarios.                                                            |
| Recycle       | The volume is wiped (basic delete of files) and made available again for a new claim. ⚠️ Deprecated.                                                                                               |

Creating a PersistentVolumeClaim `app-data.pvc.yaml`:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: app-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: "" # Empty for static provisioning
  resources:
    requests:
      storage: 256Mi
```

```bash
kubectl apply -f app-data.pvc.yaml
```

Notice now the PersistentVolume is bound to the claim.

```bash
kubectl get pvc -o wide
kubectl get pv -o wide
kubectl describe pv app-data
```

Let's create a pod to mount the volume:

```bash
kubectl run pod-with-pvc --image=busybox:1.37.0 -o yaml --dry-run=client -- /bin/sh -c "sleep infinity" > pod-with-pvc.yaml
```

```diff
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: null
    labels:
      run: pod-with-pvc
    name: pod-with-pvc
  spec:
+   volumes:
+     - name: app-data
+       persistentVolumeClaim:
+         claimName: app-data-pvc
    containers:
    - args:
      - /bin/sh
      - -c
      - "sleep infinity"
      image: busybox:1.37.0
      name: pod-with-pvc
      resources: {}
+     volumeMounts:
+       - mountPath: "/app/data"
+         name: app-data
    dnsPolicy: ClusterFirst
    restartPolicy: Always
  status: {}
```

```bash
kubectl apply -f pod-with-pvc.yaml
kubectl get pods
```

You can verify the PersistentVolume and PersistentVolumeClaim are being used by the Pod:

```bash
kubectl describe pvc/app-data-pvc pv/app-data
```

Create some content in the volume:

```bash
$ kubectl exec -it pod-with-pvc -- /bin/sh
/ $ cd /app/data
/app/data $ ls -l
/app/data $ touch test.db
/app/data $ echo '{"port": 3000}' > config.json
/app/data $ ls -l
exit
```

Recreate the pod and check files are still there.

```bash
$ kubectl delete -f pod-with-pvc.yaml --now
$ kubectl apply -f pod-with-pvc.yaml
$ kubectl exec -it pod-with-pvc -- /bin/sh
/ ls -lh /app/data
```

### StorageClass

Listing StorageClasses:

```bash
kubectl get storageclass # or `kubectl get sc`
```

StorageClasses are also created using YAML. The required field is `provisioner`. Field `parameter` is dynamic and based on the provisioner. You can configure `reclaimPolicy` and `volumeBindingMode` among others.

Create a StorageClass `ebs.sc.yaml`:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs
provisioner: kubernetes.io/aws-ebs
parameters: # based on provisioner documentation
  type: gp3
  "csi.storage.k8s.io/fstype": ext4
reclaimPolicy: Delete
volumeBindingMode: Immediate # kubectl explain sc.volumeBindingMode
```

```bash
kubectl apply -f ebs.sc.yaml
kubectl get sc
```

In order to get it working we also need to install the provisioner controller. This is not covered and not required in exam.

Let's use the `standard` StorageClass provided by Minikube and create a PersistentVolumeClaim that let `standard` StorageClass to create automatically a PersistentVolume according to claim needs.

Create file `app-data.pvc-sc.yaml`:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: app-data-pvc-sc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard # Notice this value
  resources:
    requests:
      storage: 512Mi
```

```bash
kubectl apply -f app-data.pvc-sc.yaml
kubectl get pvc # Bound to volume `pvc-<some_random_hash>`
kubectl get pv
```

Delete PersistentVolumeClaim to check volume is deleted due to `reclaimPolicy` set to `Delete`

```bash
kubectl delete -f app-data.pvc-sc.yaml
kubectl get pvc,pv
```
