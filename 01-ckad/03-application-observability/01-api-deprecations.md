# API Deprecations Exercises

## Exercise 1.

We are planing a migration in our cluster from version 1.2 to 1.30. We already have multiple manifests that operate our applications. Migrate these manifests and make sure that are compatible with Kubernetes version 1.30.

Inspect [config.yaml](./.resources/deprecated/config.yaml) and [nginx.yaml](./.resources/deprecated/nginx.yaml). Create the K8s objects from these manifests. 

Apply the modifications that are need it to make it work with 1.30 and verify that are working.
