How to set up Version control (CI/CD) in BigQuery by using Terraform.

STEPS:

1/ Set up GCP service account & download json key

2/ Set up GC bucket to store Terraform state file (infrastructure status)

3/ Terminal: set GOOGLE_CREDENTIALS = <"json key">

4/ Initialize Terraform environment for GCP (precise bucket & GCP project in providers.tf)
Terminal:
terraform init

5/ Create biqquery.tf with a link to a file with sql request (or write a request in the body)

6/Terminal: 

terraform fmt

terraform validate

7/ Version Control / Git set up - set up Actions secrets & add GCP service account json key value 

8/ Create a git workflow in terraform.yml (exclude *.tfstate)

9/ Terminal:

terraform fmt

terraform validate

git add .

git remote add origin GH_REPO

git branch -M main

git commit -m "message"

git push -u origin main

10/ Make changes to sql file or request in a body & commit them.
Terminal:

terraform fmt

terraform validate

git add .

git commit -m "message"

git push -u origin main
