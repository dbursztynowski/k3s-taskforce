# Notes

## Treat this directory as privte and do not use it.
Here, my personal version of the stuff is stored and non-standard (maybe even invalid) configurations may be present. Quit it - you are expected to do the labs according to the guides.

## Metallb https://metallb.universe.tf/installation/#installation-by-manifest

```
$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
```
now check ip-pool-config.yaml if IP address pools are OK and then
```
$ kubectl apply -f ip-pool-config.yaml
```

## Prometheus

### Installation

- kube-prometheus installation according to: 

  Recommended version v1.14

#### Install

```
$ mkdir monitoring
$ cd monitoring
$ git clone -b release-0.14 --single-branch https://github.com/prometheus-operator/kube-prometheus.git
$ cp -r kube-prometheus/manifests/* ./
$ rm -r kube-prometheus
$ cd ..
$ kubectl apply --server-side -f monitoring/setup 
$ kubectl wait \
--for condition=Established \
--all CustomResourceDefinition \
--namespace=monitoring
$ kubectl apply -f monitoring/
```


#### Tear down the stack

```
$ kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
```
### Problems

- If Prometheus does not scrape metrics form a target and you can see in the GUI or in Prometheus container logs:

_Non-compliant scrape target sending blank Content-Type and no fallback_scrape_protocol specified for target_

than install kube-prometheus v1.14, otherwise a workaround should be done according to this:

https://github.com/prometheus/prometheus/issues/15485#issuecomment-2508087753
