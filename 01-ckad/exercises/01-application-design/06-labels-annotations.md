# Labels and Annotations Exercises

## Exercise 1

Create three Pods that use the image `nginx:1.27.3`. The names of the Pods should be `app-a`, `app-b`, and `app-c`.

Assign the label `microsvc=frontend` to `app-a` and the label `microsvc=backend` to `app-b` and `app-c`. All pods should also assign the label `team=fruits`.

Assign the annotation with the key `deployed-by` to `app-a` and `app-c`. Use `jane` as the value.

From the command line, use label selection to find all Pods with the team `fruits`.

## Exercise 2

Create a Pod with the image `nginx:1.27.3` that assigns **three recommended labels**. One for defining the application name with the value `nginx`, one for defining the tool used for managing the application named `helm` and .....

Render the assigned labels of the Pod object.