terraform {
  source = "../../../../../modules/ecr"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_account_id = "YOUR_AWS_ACCOUNT"
}