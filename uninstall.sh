#!/bin/bash

# Inicio da execução do script
echo "Iniciando o script de desinstalacao..."

# Alterando o diretorio para a pasta terraform
cd ./terraform

# Executa o Terraform Destroy
echo "Destruindo a infraestrutura com Terraform..."
terraform destroy -auto-approve

# Para o container do LocalStack
echo "Parando o container do LocalStack..."
docker stop localstack

# Mensagem de conclusao
echo "Execucao concluida com sucesso :)"