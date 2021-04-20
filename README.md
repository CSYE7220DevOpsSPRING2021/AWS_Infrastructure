# kubeconfig
1. `terraform output kubeconfig > config-terraform-eks-demo`
2. (optional) `cp C:/Users/<username>/.kube/config C:/Users/<username>/.kube/config.bak`
3. `cp ./config-terraform-eks-demo C:/Users/<username>/.kube/config`
# config map
`terraform output config_map_aws_auth > ./config-map-aws-auth.yml`
`kubectl apply -f ./config-map-aws-auth.yml`
