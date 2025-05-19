# Pods

## Basic operations

Creating pods:

```bash
kubectl run httpd --image=httpd:2.4.63
kubectl get pods # or kubectl get po
```

Deleting a pod:

```bash
kubectl delete pod httpd
# Or you can use object/name
kubectl delete pod/httpd
```

Adding some flags to pod creation. Expose a port, set an environment variable and set two labels:

```bash
kubectl run httpd --image=httpd:2.4.63 --port=80 --env="APP_DOMAIN=lemoncode.net" --labels="app=webserver,profile=prod"
```

Show more information with `-o wide`:

```bash
kubectl get pods -o wide
```

Show pod labelswith `--show-labels`:

```bash
kubectl get pods --show-labels
```

Create manifest manually:

```yaml
# httpd.pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd
  labels:
    app: webserver
    profile: prod
spec:
  containers:
    - name: httpd
      image: httpd:2.4.63
      env:
        - name: APP_DOMAIN
          value: lemoncode.net
      ports:
        - containerPort: 80
```

Create pod from YAML:

```bash
kubectl delete pod httpd
kubectl apply -f httpd.pod.yaml
kubectl get pods
kubectl describe pod webserver
```

Filter pods by name:

```bash
kubectl get pod httpd
```

Create manifest from command:

```bash
kubectl delete -f httpd.pod.yaml
kubectl run httpd --image=httpd:2.4.63 --port=80 --env="APP_DOMAIN=lemoncode.net" --labels="app=webserver,profile=prod" -o yaml --dry-run=client > httpd.pod.yaml
kubectl apply -f httpd.pod.yaml
kubectl get pods
```

Check pod logs

```bash
kubectl logs httpd
kubectl logs httpd -f # watch mode
```

> You could check previous container logs if restarted using `-p` flag.

Executing commands inside a pod:

```bash
kubectl exec -it httpd -- /bin/sh
kubectl exec -it httpd -- env
kubectl exec -it httpd -- bash
```

También es posible ejecutar un comando al vuelo sin abrir una shell interactiva:

```bash
kubectl exec httpd -- env
```

Create temporal pods. Use flag `--rm` to remove pod after command exits:

```bash
kubectl run busybox --image=busybox:1.37.0 --rm -it --restart=Never -- env
```

Check `httpd` pod IP using:

```bash
kubectl get pods -o wide
```

```bash
kubectl run busybox --image=busybox:1.37.0 --rm -it --restart=Never -- sh
wget -qO- 10.244.0.8
```

## Editing pod manifests

Create a base pod definition:

```bash
kubectl run simple-pod --image=busybox:1.37.0 -o yaml --dry-run=client > simple.pod.yaml
```

Example output:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: simple-pod
  name: simple-pod
spec:
  containers:
    - name: simple-pod
      image: busybox:1.37.0
  restartPolicy: Always
```

Adding environment variables:

```diff
  spec:
    containers:
      - name: simple-pod
        image: busybox:1.37.0
+       env:
+         - name: APP_VERSION
+           value: 22.10.0
+         - name: PERSISTENCE_TYPE
+           value: s3
```

Changing `restartPolicy`:

```diff
    dnsPolicy: ClusterFirst
-   restartPolicy: Always
+   restartPolicy: OnFailure
  status: {}
```

Run pod:

```bash
kubectl apply -f simple.pod.yaml
kubectl get pods
```

Final status should be `Completed`.

Create a new pod definition changing default container command:

```bash
kubectl run uptime --image=busybox:1.36.1 -- /bin/sh -c 'while true; do echo "Still alive: $(uptime -s)"; sleep 5; done'
kubectl get pods
kubectl logs uptime -f
```

Create YAML from previous pod definition:

```bash
kubectl run uptime --image=busybox:1.36.1 -o yaml --dry-run=client -- /bin/sh -c 'while true; do echo "Still alive: $(uptime -s)"; sleep 5; done' > uptime.pod.yaml
```

You can update command definition to a multiline approach:

```diff
  - args:
    - /bin/sh
    - -c
-   - 'while true; do echo "Still alive: $(uptime -s)"; sleep 5; done'
+   - |
+     while true; do
+       echo "Still alive: $(uptime -s)"
+       sleep 5
+     done
```

Recreate pod:

```bash
kubectl delete pod/uptime --now
kubectl apply -f uptime.pod.yaml
```

> Use flag `--now` to delete pod faster. This is equivalent to `--grace-period=1`. You can also use `--grace-period=0 --force`.

Setting `args` replaces `CMD` definition in container image. Setting `command` replaces `ENTRYPOINT` definition. Update YAML to set both `args` and `command`:

```diff
  containers:
-   - args:
+   - command:
        - /bin/sh
+     args:
        - -c
        - 'while true; do echo "Still alive: $(uptime -s)"; sleep 5; done'
```

Recreate pod:

```bash
kubectl delete -f uptime.pod.yaml
kubectl apply -f uptime.pod.yaml
kubectl logs -f uptime
```

Update `simple.pod.yaml` to include `command` with a script:

```diff
    name: simple-pod
+   command:
+     - /bin/sh
+     - -c
+     - |
+       i=0
+       while true; do
+         i=$((i+1))
+         echo "Time running: ${i}s"
+         sleep 1
+       done
```

Apply changes using:

```bash
kubectl apply -f simple.pod.yaml
```

Notice the error. We cannot update an existing pod's command. We need to recreate it:

```bash
kubectl delete -f simple.pod.yaml --now
kubectl apply -f simple.pod.yaml
kubectl logs -f simple-pod
```
