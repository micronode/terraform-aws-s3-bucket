SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.28
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
	$(CHECKOV) -d /work && \
		$(CHECKOV) -d /work/modules/website

#	$(TFSEC) /work && \
#		$(TFSEC) /work/modules/website

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ > ./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/website > ./modules/website/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/website && \
		$(TERRAFORM) fmt -list=true ./examples/encrypted && \
		$(TERRAFORM) fmt -list=true ./examples/public

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan -input=false examples/$(EXAMPLE)
