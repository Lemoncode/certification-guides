# Deployment Strategies Exercise

## Exercise 1.

Create the Deployment object from the YAML manifest file `deployment-prometheus.yaml`.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
spec:
  replicas: 6
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
        - image: prom/prometheus:v2.55.1
          name: prometheus
          ports:
            - containerPort: 9090
```

You need to update all replicas with the container image `prom/prometheus:v3.0.1`. Make sure that the rollout happens in batches of two replicas at a time. 

Ensure that a readiness and liveness probes are defined.

## Exercise 2.

In this exercise, you will set up a blue-green Deployment scenario. You’ll first create the initial (blue) Deployment and expose it will a Service. Later, you will create a second (green) Deployment and switch over traffic.

Create a Deployment named `my-nginx-blue` with 2 replicas. The Pod template of the Deployment should use container image `nginx:1.27.0` and assign the label `app=blue`.

Expose the Deployment with a Service of type ClusterIP named `my-nginx`. Map the incoming and outgoing port to 80. Select the Pod with label `app=blue`.

Run a temporary Pod with the container image `alpine/curl:8.9.1` to make a call against the Service using `curl`.

Create a second Deployment named `my-nginx-green` with 2 replicas. The Pod template of the Deployment should use container image `nginx:1.27.3` and assign the label `app=green`.

Change the Service’s label selection so that traffic will be routed to the Pods controlled by the Deployment `my-nginx-green`.

Delete the Deployment named `my-nginx-blue`.

Run a temporary Pod with the container image `alpine/curl:8.9.1` to make a call against the Service.

## Exercise 3.

In this exercise, you will set up a canary Deployment. 

Use the following YAML

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stable-deployment
spec: 
  replicas: 4
  selector:
    matchLabels:
      app: nodejs 
      track: stable
  template:
    metadata:
      labels:
        app: nodejs
        track: stable
    spec:
      containers:
      - name: nodejs-app
        image: jaimesalas/ckad-guide:stable-v0.0.1
        ports:
        - containerPort: 3000
```

Expose the deployment with a `ClusterIP` service. Check that we are able to get a response by quering the service using a naked pod using the image `alpine/curl`. Use the following command to make the requests. 

```bash
EXTERNAL_IP=$1

for ((i=1;i<=20;i++))
do
    curl -s "http://$EXTERNAL_IP" | grep "<title>.*</title>"
    sleep .5s
done
```

Create  a new deployment using `jaimesalas/ckad-guide:stable-v0.0.1` that recives the 20% of overall requests. 

Check that we are getting the expected results by running the previous created pod with `alpine/curl` image.