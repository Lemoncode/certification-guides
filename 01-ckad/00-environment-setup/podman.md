# Set up VSCode and Podman

We'll cover here how to set up the Kubernetes and VSCode environment using Podman.

### Podman installation

### Linux

Refer to [Installing Podman on Linux](https://podman.io/docs/installation#installing-on-linux). You can install it from your favorite package manager.

### macOS

Download Podman CLI for macOS from official website [https://podman.io/](https://podman.io/).

### Windows

Refer to [Podman for Windows installation guide](https://github.com/containers/podman/blob/main/docs/tutorials/podman-for-windows.md). Installation will use WSL as backend. Download Podman CLI for Windows from official website [https://podman.io/](https://podman.io/).

## Post installation

Ensure you can open a new terminal and execute `podman version`. Here's an example with output:

```shell
$ podman version
Client:        Podman Engine
Version:       5.4.2
API Version:   5.4.2
Go Version:    go1.24.2
Git Commit:    be85287fcf4590961614ee37be65eeb315e5d9ff
Built:         Wed Apr  2 18:32:00 2025
Build Origin:  pkginstaller
OS/Arch:       darwin/amd64

Server:       Podman Engine
Version:      5.4.2
API Version:  5.4.2
Go Version:   go1.23.7
Git Commit:   be85287fcf4590961614ee37be65eeb315e5d9ff
Built:        Wed Apr  2 02:00:00 2025
OS/Arch:      linux/amd64
```

## Podman VM

Minikube will need a machine with at least CPUs=2 and Memory=2200MB, we need to be sure to have enough power in podman machine, otherwise Minikube will fail to start.

You can check your machines and resources with:

```bash
$ podman machine list
NAME                    VM TYPE     CREATED     LAST UP            CPUS        MEMORY      DISK SIZE
podman-machine-default  applehv     2 days ago  Currently running  6           6GiB        100GiB
```

You can delete the default machine with:

```bash
$ podman machine stop podman-machine-default
Machine "podman-machine-default" stopped successfully

$ podman machine rm podman-machine-default
The following files will be deleted:
var/folders/gn/mmk3fnw536j65dykm_18bbqm0000gn/T/podman/podman-machine-default.sock
/var/folders/gn/mmk3fnw536j65dykm_18bbqm0000gn/T/podman/podman-machine-default-gvproxy.sock
/var/folders/gn/mmk3fnw536j65dykm_18bbqm0000gn/T/podman/podman-machine-default-api.sock
/var/folders/gn/mmk3fnw536j65dykm_18bbqm0000gn/T/podman/podman-machine-default.log
Are you sure you want to continue? [y/N] y
```

You can create a new podman machine with higher resources with:

```bash
$ podman machine init \
  --cpus 6 \
  --disk-size 100 \
  --memory 6144 \
  --rootful \
  podman-machine-default

$ podman machine start
```

## Set up VSCode

In order to work with Devcontainer you'll need to install [Dev Containers extension](https://marketplace.visualstudio.com/items/?itemName=ms-vscode-remote.remote-containers).

Also you'll need to instruct VSCode to use `podman` instead of `docker` when creating the Dev Container. Go to `Code -> Preferences -> Settings`. Navigate to `Extensions -> Dev Containers` and update `Docker Path` to `podman`. You can also write this path in the search bar: `dev.containers.dockerPath`.

## Open VSCode Devcontainer

- Ensure you're in the project folder and the folder `.devcontainer` folder is on top in file explorer.
- Open command palette pressing `F1` and execute command `Dev Containers: Reopen in Container`.
- Choose `Kubernetes - Minikube-in-Docker (Podman)` profile.
- Once VSCode reloads and environment is set up open a terminal.
- Start minikube with `minikube start`
- Check cluster works with `kubectl get nodes`
