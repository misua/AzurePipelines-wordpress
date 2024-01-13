
# Project - House Atreides


This is an all Terraform to deploy the ff:


- Deploys a new AKS on 2 diff zones(1 node-1pod each zone)
- A pv & pvc inside the cluster
- wordpress w/ volume_mounts and using pvc (for /var/www/html)
- Mysql DB for wordpress deployment use
- wordpress svc,mysql svc and ingress LB
- Horizontal Pod autoscaling + Cluster autoscaling 
- the azp-agent-in-docker/ - is a microsoft agent/runner,built by podman, as my request didnt get approved for parrallelism (required by azure pipelines)

---

```replace credentials in provider.tf using your own```

---
```build dockerfile```
- podman build -t "azp-agent:linux1" --file "azp-agent.linux.dockerfile" .
- podman run -e AZP_URL="https://dev.azure.com/charlice/" -e AZP_TOKEN="mjtwprakc7g4ca2xbvoiof4se42m222kgeesdxxxrraq2kcr2u6q" -e AZP_POOL="Default" -e AZP_AGENT_NAME="Docker Agent - Linux" --name "azp-agent-linux1" azp-agent:linux1

---
``` To delete cluster faster for quick tests, use az cli```

``az aks delete --name myAKSCluster --resource-group myResourceGroup --yes --no-wait``

e.g az aks delete --name my-aks-cluster --resource-group my-Arrakis-rg --yes --no-wait

TODO
- add metrics integration like prometheus+grafana
- should probably use key vault or better password mgmt system.
- more code cleanup and using variables 

## Authors

- [@misua](https://www.github.com/misua)



`Badges`


[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
