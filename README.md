
# Project - House Atreides

This is an all Terraform to deploy the ff:


- New AKS cluster
- A pv & pvc inside the cluster
- wordpress w/ volume_mounts and using pvc (for /var/www/html)
- Mysql DB for wordpress deployment use
- wordpress svc,mysql svc and ingress LB
---  

- the azp-agent-in-docker/ - is a microsoft agent/runner,built by podman, as my request didnt get approved for parrallelism (required by azure pipelines)


```replace credentials in provider.tf using your own```




---

## Authors

- [@misua](https://www.github.com/misua)



`Badges`


[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
