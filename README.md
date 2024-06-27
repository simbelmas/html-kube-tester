# html-kube-tester

## Workload
Workload to test application behavior while making changes on infrastructure.

Ingress fqdn has to be configured by either:

* modifying file *ingress-patch-route-name.yaml*
* using this repo as kustomize source and override inn the same way than *ingress-patch-route-name.yaml*
   
*replicas* and *content-git-repo* in *config* folder can be customized by modifying files or applying kustomize patch

Connntent git will be displayed in an iframe with node name on top.

Node name is displayed on the top of the page and also in kube-node.json and on kube-node.txt

Thanks to https://github.com/amoldalwai/RoadFighter.git for having something fun to display.
