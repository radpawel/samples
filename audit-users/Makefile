.PHONY: help

DATE=$(shell date '+%Y-%m-%d%n')


ifdef config
ifneq ("$(config)", "")
aws_config_file := $(config)
endif
else
aws_config_file := "landing-zone.config"
endif


all: help
help: Makefile
	@echo ""
	@echo "Info:\n \
	make run-report (generates IAM user info; default profle \"landing-zone.config\")"
	@echo "Required:\n \
	aws-okta credentials needs to be in the keyring (authenticate with okta first to run the script)"
	@echo "Optional:\n \
	use your aws profile file (e.g. make run-report config=~/.aws/aws.config)\n"

run-report:
	@AWS_CONFIG_FILE=~/.aws/$(aws_config_file) ./main.py --config $(aws_config_file)  > "./reports/${DATE}-iam-users-report.md"
