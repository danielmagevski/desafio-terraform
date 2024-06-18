# Desafio Terraform

Este repositorio contem os recursos e scripts necessarios para implantar uma infraestrutura serverless utilizando Terraform em um ambiente Linux com Docker e Terraform.

## Pre-requisitos

- **Sistema Operacional:** Linux
- **Docker**
- **Terraform**

## Teste Automatico

O codigo já baixa a imagem do localstak e executa o terraform com init, fmt, validate e apply.
Na desinstalacao ele executa o destroy do terraform, para a imagem do localstack.

### Como instalar

Para configurar seu ambiente e instalar as dependencias necessarias, siga os passos abaixo:

```bash
chmod +x install.sh
./install.sh
```

### Como desisntalar

```bash
chmod +x uninstall.sh
./uninstall.sh
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