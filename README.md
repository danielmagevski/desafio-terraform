# Desafio Terraform

Este repositorio contem os recursos e scripts necessarios para implantar uma infraestrutura serverless utilizando Terraform em um ambiente Linux com Docker.

## Pre-requisitos

- **Sistema Operacional:** Linux
- **Docker**
- **Terraform**

## Teste Automatico

### Como instalar

Para configurar seu ambiente e instalar as dependencias necessarias, siga os passos abaixo:

```bash
chmod +x install.sh
./install.sh
```

### Recursos Implementados

```bash
terraform state list

aws_api_gateway_deployment.echo_deployment
aws_api_gateway_integration.post_integration
aws_api_gateway_method.post_method
aws_api_gateway_resource.root_resource
aws_api_gateway_rest_api.echo_api
aws_iam_policy_attachment.lambda_policy
aws_iam_role.lambda_exec
aws_lambda_function.echo_server
aws_lambda_permission.api_gateway
````