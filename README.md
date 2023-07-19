# Vagrant k8s cluster

## Get Started

```bash
vagrant up --provider=virtualbox
```

## SSH connection

```bash
$ ssh -o IdentitiesOnly=yes vagrant@192.168.56.10
```
- Default password is `vagrant`.
- Clean your `$HOME/.ssh/known-hosts` file if necessary.

## Kubernetes - kubectl
- To use `kubectl` command, you should be root user.
```bash
$ vagrant@kmaster:~$ sudo su
$ root@kmaster:/home/vagrant#
$ kubectl get nodes
```
