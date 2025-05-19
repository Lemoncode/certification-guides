# Namespaces

## Working with Namespaces

List namespaces

```bash
kubectl get namespaces
kubectl get ns
```

Creating a namespace

```bash
kubectl create namespace lemoncode
kubectl get namespace lemoncode
```

Inspect namespace (or another object) details:

```bash
kubectl describe namespace lemoncode
```

Create YAML definition from imperative command:

```bash
kubectl create namespace lemoncode -o yaml --dry-run=client > lemoncode.ns.yaml
```

Inspect objects in namespace using `-n`:

```bash
kubectl get pods -n kube-system
```

Setting namespace in current context. This ensures all commands are executed in a specific namespace without appending `-n <namespace_name>` flag:

```bash
# List contexts
kubectl config get-contexts
# Set namespace
kubectl config set-context --current --namespace lemoncode
# List pods in current namespace (lemoncode)
kubectl get pods
```

We can also check namespace from config file:

```bash
kubectl config view --minify | grep namespace:
```

Restore namespace in current context to `default`:

```bash
kubectl config set-context --current --namespace=default
```

Delete a namespace. Deleting a namespace will also delete all objects in that namespace.

```bash
kubectl delete namespace lemoncode
```

Create a namespace from YAML:

```bash
kubectl apply -f lemoncode.ns.yaml
```
