## Info 

POC of a Django app with a reverse proxy running in AWS ECS.


    ~/bayer pradko-pradko (eu-west-1) on ☁️  (us-central1)
    ➜ tree .
    .
    ├── Makefile
    ├── README.md
    ├── src
    │   ├── django-app
    │   │   ├── Dockerfile
    │   │   ├── app
    │   │   │   ├── db.sqlite3
    │   │   │   ├── django_project
    │   │   │   │   ├── __init__.py
    │   │   │   │   ├── __pycache__
    │   │   │   │   │   ├── __init__.cpython-310.pyc
    │   │   │   │   │   ├── settings.cpython-310.pyc
    │   │   │   │   │   ├── urls.cpython-310.pyc
    │   │   │   │   │   └── wsgi.cpython-310.pyc
    │   │   │   │   ├── asgi.py
    │   │   │   │   ├── settings.py
    │   │   │   │   ├── urls.py
    │   │   │   │   └── wsgi.py
    │   │   │   └── manage.py
    │   │   └── requirements.txt
    │   └── nginx
    │       ├── Dockerfile
    │       └── conf
    │           ├── default.conf
    │           ├── localhost-key.pem
    │           └── localhost.pem
    └── terraform
        ├── envs
        │   ├── django-dev
        │   │   └── regions
        │   │       └── eu-west-1
        │   │           ├── ecr
        │   │           │   └── terragrunt.hcl
        │   │           └── main
        │   │               └── terragrunt.hcl
        │   └── terragrunt.hcl
        └── modules
            ├── ecr
            │   ├── backend.tf
            │   ├── main.tf
            │   ├── provider.tf
            │   ├── variables.tf
            │   └── versions.tf
            └── main
                ├── backend.tf
                ├── main.tf
                ├── provider.tf
                ├── variables.tf
                └── versions.tf

    17 directories, 33 files



### Initial Steps

- Use a project-specific profile allowing to create of resources in AWS

        export AWS_PROFILE=pradko-pradko
        aws sts get-caller-identity
        aws sts get-caller-identity | jq '.Account'

- Update files with your accountID

        ➜ grep -lr YOUR_AWS_ACCOUNT  .
        ./terraform/modules/main/main.tf
        ./terraform/envs/django-dev/regions/eu-west-1/ecr/terragrunt.hcl
        ./terraform/envs/django-dev/regions/eu-west-1/main/terragrunt.hcl
        ./Makefile


- Create ECR repo:

        pushd terraform/envs
        terragrunt apply-all --terragrunt-non-interactive

> NOTE: Once ECR repo is initialized, let's upload images.


- Run command to build images and push them to the registry
        
        popd
        make all

- Deploy once more 
        
        pushd terraform/envs
        terragrunt apply-all --terragrunt-non-interactive


- Get a Public IP address and test

- Clean up and destroy all

        terragrunt destroy-all --terragrunt-non-interactive



## Local Tests

```bash
docker network create --driver bridge django-app-base
docker run -d --rm --name=django-app-base -p 8000:8000  django-app-base
docker network inspect django-app-base | jq '.[].IPAM.Config[].Gateway' 
# replace localhost ip default.conf with the gateway IP & build an image
docker run -d --rm --name=nginx-django-app-base --network=django-app-base -p 80:80 -p 443:443 nginx-django-app-base

```


### Test nginx config 

docker exec nginx-base nginx -t
docker exec nginx-base nginx -s reload

