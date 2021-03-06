SHELL:=/bin/bash
AWS_ACCOUNT?=`aws sts get-caller-identity | jq -r '.Account'`
AWS_DEFAULT_REGION?=ap-southeast-2

TERRAFORM_VERSION=0.13.4
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

TERRAFORM_DOCS=docker run --rm -v "${PWD}:/work" tmknom/terraform-docs

CHECKOV=docker run --rm -t -v "${PWD}:/work" bridgecrew/checkov

TFSEC=docker run --rm -it -v "${PWD}:/work" liamg/tfsec

DIAGRAMS=docker run -t -v "${PWD}:/work" figurate/diagrams python

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/website && $(TERRAFORM) validate modules/website

test: validate
	$(CHECKOV) -d /work

	#$(TFSEC) /work

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ > ./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/website > ./modules/website/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/website && \
		$(TERRAFORM) fmt -list=true ./examples/encrypted && \
		$(TERRAFORM) fmt -list=true ./examples/public && \
		$(TERRAFORM) fmt -list=true ./examples/terraform-state

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan -state=$(AWS_ACCOUNT).tfstate -input=false examples/$(EXAMPLE)
