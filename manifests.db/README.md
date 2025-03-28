# Notes

- If Prometheus does not scrape metrics form a target and you can see in the GUI or in Prometheus container logs:

_Non-compliant scrape target sending blank Content-Type and no fallback_scrape_protocol specified for target_

than install kube-prometheus v1.14, otherwise a workaround should be done according to this:

https://github.com/prometheus/prometheus/issues/15485#issuecomment-2508087753
