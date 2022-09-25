# AWSServiceCatalog-tf-poc


## Add a new product

#### Update product variable


```terraform
ElasticSearch-prod = ({
    stage             = "prod"
    name              = "ElasticSearch-prod"
    owner             = "cloud-core"
    description       = "ElasticSearch domain with configurable setup."
    params = [{
        description   = "AWS ElasticSearch reference with dev pre-configured settings - v0.1"
        name          = "v0.1"
        template_url  = "https://test1.s3.us-west-2.amazonaws.com/template-v2.yaml"
      },
    ]
    templates = {
    }
  })

```

#### Add a new product version

```terraform
    ElasticSearch-prod = ({
    stage             = "prod"
    name              = "ElasticSearch-prod"
    owner             = "cloud-core"
    description       = "ElasticSearch domain with configurable setup."
    params = [{
        description   = "AWS ElasticSearch reference with dev pre-configured settings - v0.1"
        name          = "v0.1"
        template_url  = "https://test1.s3.us-west-2.amazonaws.com/template-v2.yaml"
      },
    ]
    templates = {
      1 = {
        version     = "v0.2"
        template    = "https://test1.s3.us-west-2.amazonaws.com/template.yaml"
        description = "AWS ElasticSearch reference with dev pre-configured settings - v0.2"
        guidance    = "DEPRECATED"
      }
    }
  })

```