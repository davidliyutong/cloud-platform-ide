# code-server-speit

Code server for SPEIT C/C++ Programming course

## Introduction

- Supported code-server versions: 3.12.0 - 4.7.0

## How to build

1. Step 1: `scrips/bootstrap.sh`

    Run `scrips/bootstrap.sh` to download coder-server release

    Usage:

    ```shell
    ./scripts/build/bootstrap.sh <arch> <version>
    ```

    e.g.

    ```shell
    ./scripts/build/bootstrap.sh amd64 4.7.0
    ```

    or

    ```shell
    ./scripts/build/bootstrap.sh
    ```

    > This will download latest release for amd64

    > Check [https://github.com/coder/code-server/releases](https://github.com/coder/code-server/releases) for supported architectures and versions.

    The bootstrap.sh will create `./home` directory with following structure

    ```text
    home
    └── .config
        └── code-server
            ├── CONFIGURED
            └── config.yaml
    ```

2. Step 2: `script/build.sh`
    Run `script/build.sh`

## How to use

The container expose port `8080`. If the container is behind proxy, then the proxy must support both HTTP and Websocket connections.

Basically, the container provide an interface of code-server.

## Reboot the container

To reboot container, kill the daemon process inside container.

```shell
kill $(ps -ef|grep "/usr/bin/lib/node /usr/bin --config /root/.config/code-server/config.yaml" |grep -v grep |awk '{print $2}')
```

> `alias restart-container="kill $(ps -ef|grep "/usr/bin/lib/node /usr/bin --config /root/.config/code-server/config.yaml" |grep -v grep |awk '{print $2}')"` could be added to shell profile

## Reset the container

The `home` directory will be packed copied to `/tmp/home.tar` of the container. During the initialization The entry script `docker-entrypoint.sh` will check the existence of `/root/.config/code-server/CONFIGURED`. If this file does not exist, the script will extrat the content of `/tmp/home.tar` to `/root`, which will overwrite `/root/.config`.

To reset the container, simply perform delete `/root/.config/code-server/CONFIGURED` in the container and reboot the container.

> Warning: this will reset password to default

## Change password

Edit `/root/.config/code-server/config.yaml` in the container. Modify the `password` key-value pair

```yaml
bind-addr: 0.0.0.0:8080
auth: password
password: changeme
cert: false
```

Reboot the container to make changes take effect.

## How to deploy to K8S clusters

Requirement:

 - ingress controller installed
 - default storage class configured
 - a tls secret to secure ingress traffic (optional)

Their is this `deployment/deployment-template.yaml` template. During deployment the `{{ID}}` should be replaced with unique user identifiers. The lines marked with `CHANGE` me should be modified according to your cluster configuration

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: code-server-pvc-{{ID}}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi # CHANGEME Storage Limit
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    k8s-app: apps.code-server-{{ID}}
  name: code-server-{{ID}}
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: apps.code-server-{{ID}}
  template:
    metadata:
      labels:
        k8s-app: apps.code-server-{{ID}}
    spec:
      containers:
      - image: davidliyutong/code-server-speit:v4.9.1  # CHANGEME
        imagePullPolicy: IfNotPresent
        name: container-0
        ports:
        - containerPort: 8080
          name: 8080tcp
          protocol: TCP
        resources: # CHANGEME
          limits:
            cpu: "4"
            memory: 4Gi
          requests:
            cpu: 50m
            memory: 512Mi
        securityContext:
          allowPrivilegeEscalation: true
          capabilities: {}
          privileged: false
          readOnlyRootFilesystem: false
        volumeMounts:
        - mountPath: /root
          name: home
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      volumes:
      - name: home
        persistentVolumeClaim:
          claimName: code-server-pvc-{{ID}}
---
apiVersion: v1
kind: Service
metadata:
  name: code-server-svc-{{ID}}
spec:
  ports:
  - name: 8080tcp
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    k8s-app: apps.code-server-{{ID}}
  sessionAffinity: None
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations: 
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  name: coder-server-ingress-{{ID}}
spec:
  ingressClassName: public
  rules:
  - host: example.org # CHANGEME
    http:
      paths:
      - backend:
          service:
            name: code-server-svc-{{ID}}
            port:
              number: 8080
        path: /{{ID}}(/|$)(.*)
        pathType: Prefix
  tls:
  - hosts:
    - example.org # CHANGEME hostname
    secretName: tls-example-org # CHANGEME TLS Secret
```

Apply the rendered template with `kubectl`

```shell
kubectl apply -f deployment/deployment.id.yaml -n <namespace>
```

### render

`scripts/crd/render.go` provide a simple render of template that can replace `{{ID}}` with from `csv` file or integers. For example

```shell
go build scripts/crd/render.go
./render --template_path=./deployment/deployment-template.yaml --mode=csv --csv_path=./id.csv
```

`./id.csv`:

```csv
001,...
002,...
003,...
```

This will create `deployment-001.yaml`, `deployment-002.yaml` and `deployment-003.yaml`
