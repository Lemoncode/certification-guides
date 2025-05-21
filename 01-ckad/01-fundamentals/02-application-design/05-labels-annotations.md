# Labels and Annotations

## Labels

Labels are an essential tool for querying, filtering, and sorting Kubernetes objects. Annotations only represent descriptive metadata for Kubernetes objects but can't be used for queries.

Creating objects with labels imperatively:

```bash
kubectl run labeled-pod --image=httpd:2.4.63 --labels=app=webserver,type=backend
kubectl get pods --show-labels
```

Adding labels to an existing YAML:

```bash
kubectl run labeled-pod --image=httpd:2.4.63 -o yaml --dry-run=client > labeled-pod.yaml
```

```diff
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: null
    labels:
-      run: labeled-pod
+      app: webserver
+      type: backend
    name: labeled-pod
  spec:
    containers:
    - image: httpd:2.4.63
      name: labeled-pod
      resources: {}
    dnsPolicy: ClusterFirst
    restartPolicy: Always
  status: {}
```

```bash
kubectl delete pod/labeled-pod
kubectl apply -f labeled-pod.yaml
```

Inspecting labels using describe

```bash
kubectl describe pod labeled-pod | grep -A1 Labels:
```

We can modify label on existing objects using `kubectl label`.

Adding a label:

```bash
kubectl label pod labeled-pod role=webserver
kubectl get pod/labeled-pod --show-labels
```

Replacing an existing label:

```bash
kubectl label pod labeled-pod app=httpd --overwrite
kubectl get pod labeled-pod --show-labels
```

Deleting a label:

```bash
kubectl label pod labeled-pod app-
kubectl get pod labeled-pod --show-labels
```

### Label selection

Labels are useful to perform queries and filters. Let's create three services with some labels:

```bash
kubectl run microsevice-a --image=httpd:2.4.63 --labels=role=microservice,team=saturn
kubectl run microsevice-b --image=httpd:2.4.63 --labels=role=microservice,team=mercury,version=2.0.0
kubectl run microsevice-c --image=httpd:2.4.63 --labels=role=microservice,team=pluto
```

Using `-l <criteria>` flag on `kubectl get` we can filter pods:

```bash
kubectl get pods --show-labels -l role=microservice # match pods with role "microservice"
kubectl get pods --show-labels -l team=pluto # match pods with team "pluto"
kubectl get pods --show-labels -l team=mercury,version=2.0.0 # match pods with team "mercury" and "version 2.0.0"
kubectl get pods --show-labels -l role # match pods with label "role" set
kubectl get pods --show-labels -l 'team in (mercury, pluto)' # match pods with team "mercury" or team "pluto"
kubectl get pods --show-labels -l 'team in (saturn, pluto),version' # match pods with (team "mercury" or team "pluto") and label "version" set
kubectl get pods --show-labels -l 'team != mercury,team' # match pods with team label set and not being equals to "mercury"
```

Labels are important for objects like Deployments, Services or NetworkPolicies in order to select pods by labels and apply specific functionallity to work.
Here's an example of a Service that routes traffic to pods with label `app=httpd`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpd-service
spec:
  type: ClusterIP
  selector:
    app: httpd
  ports:
    - port: 80
      targetPort: 80
```

### Recommended Labels

Kubernetes proposes a list of [recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/), all of which start with the key prefix `app.kubernetes.io`.

## Annotations

Annotations are declared similarly to labels, but they serve a different purpose. They represent key-value pairs for providing descriptive metadata. They cannot be used to select or filter pods.

Running an annotated pod:

```bash
kubectl run annotated-pod --image=httpd:2.4.63 --annotations="description=This is a web server"
kubectl get pods
kubectl describe pod/annotated-pod | grep "Annotations:"
```

Adding annotations to a YAML:

```bash
kubectl run annotated-pod --image=httpd:2.4.63 -o yaml --dry-run=client > annotated-pod.yaml
```

```diff
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: null
    labels:
      run: annotated-pod
+   annotations:
+     description: This is a web server
    name: annotated-pod
  spec:
```

```bash
kubectl delete pod/annotated-pod
kubectl apply -f annotated-pod.yaml
kubectl describe pod/annotated-pod | grep "Annotations:"
```

We can also change annotation on live objects, same as labels with `kubectl annotate`.

Creating annotation:

```bash
kubectl annotate pod annotated-pod branch=test author=Santiago
kubectl describe pod/annotated-pod | grep -A3 "Annotations:"
```

Replace annotation:

```bash
kubectl annotate pod annotated-pod "branch=main" --overwrite
kubectl describe pod/annotated-pod | grep -A3 "Annotations:"
```

Deleting annotation:

```bash
kubectl annotate pod annotated-pod author-
kubectl describe pod/annotated-pod | grep -A3 "Annotations:"
```

## Reserved Labels and Annotation

Kubernetes defines a list of reserved labels and annotations that it will evaluate at runtime to control the runtime behavior of the object.
[https://kubernetes.io/docs/reference/labels-annotations-taints/](https://kubernetes.io/docs/reference/labels-annotations-taints/)
