terraform {
  source = "../../../../../modules/main"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_account_id = "YOUR_AWS_ACCOUNT"
  my_subnets = ["subnet-03fd406cd9071fa80", "subnet-01fd9e28248a7250d"]
}