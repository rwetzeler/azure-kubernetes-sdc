## Standup an Azure Kubernetes Cluster ##

`az group deployment create --template-file template.json --parameters parameters.json --resource-group AKSCluster`

![aks standup](images/aks-standup.png)

## Set default credentials ##

`az aks get-credentials --resource-group AKSCluster --name wws-agrisync-aks-etl2 --overwrite-existing`

![set kubectl](images/set_kubectl.png)

## Check Config ##

`kubectl get nodes`

![get nodes](images/get_nodes.png)
