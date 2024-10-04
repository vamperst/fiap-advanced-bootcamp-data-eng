#!/bin/bash

# Pega primeiro parameto passado para o script
BUCKET_NAME=$1

# Verifica se o bucket já existe, caso não exista, cria o bucket
aws s3 ls s3://$BUCKET_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Bucket $BUCKET_NAME não existe."
    aws s3 mb s3://$BUCKET_NAME
    # Verifica se o bucket foi criado com sucesso
    if [ $? -eq 0 ]; then
        echo "Bucket $BUCKET_NAME criado com sucesso."
    else
        echo "Falha ao criar o bucket $BUCKET_NAME."
    fi
else
    echo "Bucket $BUCKET_NAME já existe."
    exit 1
fi

# Desconpacta o arquivo s3-parts.zip

sudo mkdir /mnt/s3
sudo zip -s 0 s3-parts.zip --out /mnt/s3.zip
sudo unzip /mnt/s3.zip /mnt/s3
sudo rm /mnt/s3.zip

# Copia os arquivos para o bucket S3
echo "Copiando arquivos para o bucket S3"
aws s3 cp /mnt/s3 s3://$BUCKET_NAME/data/ --recursive

# Copia customer para seu S3
echo "Copiando customer para seu S3"
aws s3 cp s3://redshift-downloads/TPC-DS/100GB/customer/ s3://$BUCKET_NAME/customer/ --recursive

# Copia date_dim para seu S3
echo "Copiando date_dim para seu S3"
aws s3 cp s3://redshift-downloads/TPC-DS/100GB/date_dim/ s3://$BUCKET_NAME/date_dim/ --recursive

# Copia time_dim para seu S3
echo "Copiando time_dim para seu S3"
aws s3 cp s3://redshift-downloads/TPC-DS/100GB/time_dim/ s3://$BUCKET_NAME/time_dim/ --recursive

# Copia web_sales para seu S3
echo "Copiando web_sales para seu S3"
aws s3 cp s3://redshift-downloads/TPC-DS/100GB/web_sales/ s3://$BUCKET_NAME/web_sales/ --recursive

echo "O nome do seu bucket é: $BUCKET_NAME"
echo "Fim do script"