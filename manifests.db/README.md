# Notes

## Prometheus

### Installation

- kube-prometheus installation according to: 

  Recommended version v1.14

  Install

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

### Problems

- If Prometheus does not scrape metrics form a target and you can see in the GUI or in Prometheus container logs:

_Non-compliant scrape target sending blank Content-Type and no fallback_scrape_protocol specified for target_

than install kube-prometheus v1.14, otherwise a workaround should be done according to this:

https://github.com/prometheus/prometheus/issues/15485#issuecomment-2508087753
