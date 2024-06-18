  #!/bin/bash

# Imprime uma mensagem indicando o início da execução do script
echo "Iniciando o script de automação..."

# Checar se o Docker esta instalado
if ! command -v docker &> /dev/null | echo "Docker esta instalado"
then
    echo "Erro: Docker não está instalado. Instale o Docker e tente novamente."
    exit 1
fi

# Checar se o Terraform está instalado
if ! command -v terraform &> /dev/null | echo "Terraform esta instalado"
then
    echo "Erro: Terraform nao esta instalado. Instale o Terraform e tente novamente."
    exit 1
fi

# Iniciar o container do LocalStack
echo "Iniciando o LocalStack..."
docker stop localstack > /dev/null 2>&1
docker run \
  --rm -dit \
  --name localstack \
  -p 127.0.0.1:4566:4566 \
  -p 127.0.0.1:4510-4559:4510-4559 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  localstack/localstack

# Espera um momento para garantir que o LocalStack esteja pronto
sleep 10

# Alterando o diretorio para a pasta terraform
cd ./terraform

# Executa o Terraform Init
echo "Executando terraform init..."
terraform init

# Executa o Terraform fmt
echo "Executando terraform fmt..."
terraform fmt

# Executa o Terraform validate
echo "Executando terraform validate..."
terraform validate

# Executa o Terraform apply
echo "Executando terraform plan..."
terraform apply -auto-approve

# Imprime uma mensagem indicando o início da execução do script
echo "Buscando URL do API Gateway..."

# Comando para pegar a saída do Terraform e extrair a URL
URL=$(terraform output | grep "api_gateway_url" | awk -F'"' '{print $2}') && export URL

# Realiza um teste de POST na URL extraída usando curl
echo "Enviando requisição POST para a URL..."
curl -d 'teste' "$URL"

echo "Execucao concluida com sucesso :)"