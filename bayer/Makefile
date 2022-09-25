.PHONY: build-app

help: Makefile
	@echo "Help:\n \
	Run below command to build django app:\n \
	\tmake build-app\n \
	Run below command to build build nginx app:\n \
	\tmake build-nginx"

build-app:
	cd src/django-app && docker build -t django-app-base .

build-nginx:
	cd src/nginx && docker build -t nginx-django-app-base .


login-to-ecr:
	@aws ecr get-login-password --profile pradko-pradko --region eu-west-1 | docker login --username AWS --password-stdin  YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com

push-app-image: login-to-ecr
	docker tag django-app-base:latest  YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/django-app 
	docker push  YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/django-app

push-nginx-image: login-to-ecr
	docker tag nginx-django-app-base:latest  YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/nginx-app 
	docker push  YOUR_AWS_ACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/nginx-app


all: build-app build-nginx push-app-image push-nginx-image
