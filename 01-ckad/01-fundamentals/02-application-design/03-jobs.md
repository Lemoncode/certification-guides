# Jobs & CronJob

## Job

Creating a job:

```bash
kubectl create job random-sum --image=busybox:1.37.0 -- /bin/sh -c 'total=0; counter=0; for i in $(seq 1 20); do total=$((counter + RANDOM)); echo "Still executing..."; sleep 1; done; echo "Finished. Total: $total"'
```

A job will create a pod to run the task.

Listing jobs and pods

```bash
kubectl get jobs,pods
kubectl get pods
```

Check container logs from job:

```bash
kubectl logs random-sum-nslrd -f
```

Defininig a job via YAML. Create `random-sum.job.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: random-sum
spec:
  template: # pod template:
    spec:
      restartPolicy: Never # `Never` or `OnFailure`. `Always` is not allowed.
      containers:
        - name: random-sum
          image: busybox:1.37.0
          command:
            - /bin/sh
            - -c
            - |
              total=0
              for i in $(seq 1 20); do
                total=$((total + RANDOM))
                echo "Still executing..."
                sleep 1
              done
              echo "Finished. Total: $total"
```

When a job finishes pods and jobs are not deleted by default. You can check with:

```bash
kubectl get jobs,pods
```

Delete the job and recreate with YAML:

```bash
kubectl delete random-sum
kubectl apply -f random-sum.job.yaml
```

A job can be configured with `completions` to specify how many times we need the task to complete successfully and `parallelism` to specify how many pods from the job can be run at the same time. By default `completions` is set to `1` and `parallelism` is set to `1` meaning one pod will be executed at a the job will be marked as completed as long as the pod will exit successfully. We can tweak these values to create different job types:

| completions | parallelism | Job                                                                                                                                                                                  |
| ----------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1           | 1           | Non parallel job. Will execute a pod and job will be finished as long as the pod finishes                                                                                            |
| unset (1)   | >=1         | Parallel job with one task. Will spawn as many pods as marked in `parallelism`. Job will be finished as long as one pod exist successfully and all pods finish                       |
| >=1         | >=1         | Parallel job with fixed completions. Will spawn as many pods as marked in `parallelism` and finishes when the total number of successful completions equals the `completions` value. |

Let's update our YAML:

```diff
  spec:
+   parallelism: 2
+   completions: 5
    template:
      spec:
        restartPolicy: Never
```

Recreate the job:

```bash
kubectl delete -f random-sum.job.yaml
kubectl apply -f random-sum.job.yaml
kubectl get jobs
kubectl get pods -w
```

So far so good, but what happens if pod fails to do the task? A job has a field `backoffLimit` that will spawn a new pod as long as the previous one fails. The default value is `6`. Let's update our job definition to make it fail:

```diff
  spec:
+   backoffLimit: 3
    template:
      spec:
        restartPolicy: Never
        containers:
          - name: random-sum
            image: busybox:1.37.0
            command:
              - /bin/sh
              - -c
              - |
-               total=0
-               counter=0
-               for i in $(seq 1 20); do
-                 total=$((counter + RANDOM))
-                 echo "Still executing..."
-                 sleep 1
-               done
-               echo "Finished. Total: $total"
+               echo "Doing something..."
+               sleep 1
+               echo "Oops, failed to do that"
+               exit 1
```

Recreate the job:

```bash
kubectl delete -f random-sum.job.yaml
kubectl apply -f random-sum.job.yaml
kubectl get jobs
kubectl get pods -w
```

Notice it will spawn up to 4 pods (`backoffLimit` + 1). Depending of the value of `.spec.template.spec.restartPolicy` `backoffLimit` will behave differently:

- If we set value to `Never` it will spawn a new pod to try to complete the task.
- If we set value to `OnFailure` then the same pod will be reuse and will be restarted. The value in `backoffLimit` will indicate now how many time to restart the pod before considering the job failed. Using this approach will difficult debugging since we can only inspec logs from current container and previous one in a pod so, unless you have some kind of external persistency configured you will lose logs from multiple containers. After `backoffLimit` is reached the pod is deleted.

Update `restartPolicy` to `OnFailure` and recreate the job:

```diff
  template:
    spec:
-     restartPolicy: Never
+     restartPolicy: OnFailure
      containers:
        - name: random-sum
```

```bash
kubectl delete -f random-sum.job.yaml
kubectl apply -f random-sum.job.yaml
kubectl get jobs
```

Notice after reaching `backoffLimit` the job is marked as failed and the pod is deleted.

```bash
kubectl get jobs,pods
```

## CronJob

The CronJob on the other hand is an abstraction one level above the Job that creates new Jobs periodically based on a scheduler, so, the CronJob creates Jobs, the Job creates Pods and the Pod creates containers. The scheduler is expressed with cron syntax.

```plain
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday)
# │ │ │ │ │                                   OR sun, mon, tue, wed, thu, fri, sat
# │ │ │ │ │
# │ │ │ │ │
# * * * * *
```

We can create a cronjob using job syntax but we need to specify a `--schedule` argument:

```bash
kubectl create cronjob soft-work --schedule="* * * * *" --image=busybox:1.37.0 -- /bin/sh -c 'echo "Start Work..."; sleep 10; echo "Done"'
kubectl get cj
```

This will create a CronJob that will create Jobs every minute. You can get more familiar with schedule syntax using [https://crontab.guru/](https://crontab.guru/).

Remember you can always create the YAML from the imperative command in order to edit some fields:

```bash
kubectl create cronjob soft-work o yaml --dry-run=client --schedule="* * * * *" --image=busybox:1.37.0 -- /bin/sh -c 'echo "Start Work..."; sleep 10; echo "Done"' > soft-work.cj.yaml
```

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: soft-work
spec:
  schedule: "* * * * *"
  jobTemplate: # job definition
    metadata:
      name: soft-work
    spec:
      template: # pod definition
        spec:
          restartPolicy: OnFailure
          containers:
            - name: soft-work
              image: busybox:1.37.0
              command:
                - /bin/sh
                - -c
                - |
                  echo "Start Work..."
                  sleep 10
                  echo "Done"
```

You can check after some minutes all created objects:

```bash
kubectl get cj,job,pod
```

You can perform a quick filter with:

```bash
kubectl get pods --show-labels | grep "job-name=soft-work" | awk '{print $1}' | xargs kubectl get pod
```

Jobs and Pods created by CronJob are not deleted. We can limit how many jobs and pods to keep in the cluster by setting `successfulJobsHistoryLimit` and `failedJobsHistoryLimit`. You can check current values with:

```bash
kubectl get cronjob soft-work -o yaml | grep -E "(successful|failed)JobsHistoryLimit:"
```

Let's configure these values in YAML file:

```diff
  spec:
+   successfulJobsHistoryLimit: 6
+   failedJobsHistoryLimit: 3
    schedule: "* * * * *"
    jobTemplate:
```

```bash
kubectl delete cronjob soft-work
kubectl apply -f soft-work.cronjob.yaml
kubectl get cj
```

### Schedule

Let's see some schedule examples:

| Schedule            | Meaning                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------- |
| `0 0 * * *`         | Everyday at midnight                                                                      |
| `0 0-6/2 * * *`     | Every day at 00:00, 02:00, 04:00 and 06:00                                                |
| `*/10 8-17 * * 1-5` | Every 10 minutes between 08:00 and 17:00 (last execution is 17:50), Monday through Friday |
| `5 4 1-7 * 1`       | On the first Monday of the month at 04:05 a.m.                                            |
| `0 9-17/2 * * 1-5`  | Every 2 hours between 09:00 and 17:00, from Monday to Friday (mon-fri)                    |
| `15 14 1 * *`       | At 14:15 on the 1st day of each month                                                     |
| `0 0 1 */3 *`       | At midnight on the 1st of each month, every 3 months                                      |
| `30 6 * * 1,3,5`    | At 06:30 every Monday, Wednesday and Friday                                               |
| `45 23 28-31 * *`   | At 11:45 p.m. from the 28th to the 31st of each month                                     |
| `0 12 15 6 *`       | At noon on June 15                                                                        |
