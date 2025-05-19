# Troubleshooting Exercises

## Exercise 1.

We are going to practice our troubleshooting skills by inspecting a misconfigured Application. Open [wrong App Pod](.resources/troubleshooting/pod.yaml). The code that this Pod runs when is started is as follows:

```python
import time

try:
    with open('/root/tmp/myfile.txt', 'x') as file:
        pass  # File created if it doesn't exist
except FileExistsError:
    print("File already exists.")
except Exception as e:
    print(e)

while True:
    time.sleep(20)
    print("Idle...")

```

Create a new Pod from the YAML manifest in the file *pod.yaml*. Check the Pod’s status. Do you see any issue?

Render the logs of the running container and identify an issue. Shell into the container. Can you verify the issue based on the rendered log message?

Suggest solutions that can fix the root cause of the issue.

## Exercise 2. 

We are going to inspect the metrics collected by metrics server. Open `.resources/stress`, the folder contains four pods:  *stress-a-pod.yaml*, *stress-b-pod.yaml*, *stress-c-pod.yaml* and *stress-d-pod.yaml*. Inspect those manifest files.

Create the namespace `stress-demo` and deploy the Pods inside of `stress-demo` namespace.

Use the data available through the metrics server to identify which of the Pods consumes the most memory.

Since we are using `minikube` you can start the *Metris Server* as an addon. Before start `minikube`, run the following command:

```bash
minikube addons enable metrics-server
```
