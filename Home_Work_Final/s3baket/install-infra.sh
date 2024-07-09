mv s3-create.tf s3-create.tf_
mv vm.tf_ vm.tf
TF_IN_AUTOMATION=1 terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve