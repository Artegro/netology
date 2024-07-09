terraform init
TF_IN_AUTOMATION=1 terraform apply -auto-approve
mv s3.tf_ s3.tf
terraform init -reconfigure
