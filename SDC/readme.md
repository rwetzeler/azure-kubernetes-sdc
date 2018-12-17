# Setup Streamsets Data Collector in Kubernetes #


1. Create Docker Container yaml file or use your favorite version
1. Apply the file to your Kubernetes Cluster
![set kubectl](images/sdc_install.png)

1. You may need to fix security so that SDC can work with the Azure Load Balancer
![set kubectl](images/sdc_LoadBalancer_RBAC_ERROR.png)

`kubectl create clusterrolebinding datacollector --clusterrole=cluster-admin --serviceaccount=default:kubernetes-dashboard
`


https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files


References:
[Based from this post](https://streamsets.com/blog/scaling-streamsets-kubernetes/)
