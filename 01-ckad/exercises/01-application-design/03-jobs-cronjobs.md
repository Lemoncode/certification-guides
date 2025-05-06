# Jobs and CronJobs Exercises

## Exercise 1.

Create a Job named `date-base64` using the container image `alpine:3.20` that executes the shell command `date | base64 | head -c 32`. Configure the Job to execute with three Pods in parallel. The number of completions should be set to 7.

Identify the Pods that executed the shell command. How many Pods do expect to exist?

Retrieve the generated 'date' from one of the Pods.

Delete the Job. Will the corresponding Pods continue to exist?

## Exercise 2.

Create a new CronJob named `lemon-ping`. When executed, the Job should run a `curl` command for `https://lemoncode.net/`. Use alpine/curl, or other image that comes with `curl`, already installed. The excution should occur every three minutes.

Tail the logs of the CronJob at runtime. Check the command-line options of the relevant command or consult the Kubernetes documentation.

Reconfigure the CronJob to retain a history of five executions.

Reconfigure the CronJob to disallow a new execution if the current execution is still running. Consult the Kubernetes documentation for more information.