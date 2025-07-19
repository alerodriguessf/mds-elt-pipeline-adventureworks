#!/bin/bash

echo "🔧 Setting up environment variables"
source .env

export DATABRICKS_HOST=$DATABRICKS_HOST
export DATABRICKS_TOKEN=$DATABRICKS_TOKEN
export DATABRICKS_CATALOG=$DATABRICKS_CATALOG
export DATABRICKS_SCHEMA_RAW=$DATABRICKS_SCHEMA_RAW
export DATABRICKS_VOLUME=$DATABRICKS_VOLUME
export DATABRICKS_BASE_PATH=dbfs:/Volumes/${DATABRICKS_CATALOG}/${DATABRICKS_SCHEMA_RAW}/${DATABRICKS_VOLUME}

echo "✅ Variáveis de ambiente carregadas com sucesso"
echo "----------------------------------------------"

########################################################
# 1️⃣ SQL Server: Extração e envio para o Databricks
########################################################

echo "🚀 Extraindo dados do SQL Server..."
meltano run tap-mssql target-parquet-sqlserver

echo "🧹 Limpando diretório anterior do SQL Server no DBFS..."
databricks fs rm -r ${DATABRICKS_BASE_PATH}/sqlserver || true

echo "📤 Enviando arquivos SQL Server para o Databricks..."
databricks fs cp \
  output/docker_elt/sqlserver/ \
  ${DATABRICKS_BASE_PATH}/sqlserver/ \
  --recursive

echo "✅ SQL Server carregado com sucesso!"
echo "----------------------------------------------"

########################################################
# 2️⃣ API REST: Extração e envio para o Databricks
########################################################

echo "🚀 Extraindo dados da API..."
meltano run tap-rest-api-msdk target-parquet-api

echo "🧹 Limpando diretório anterior da API no DBFS..."
databricks fs rm -r ${DATABRICKS_BASE_PATH}/api || true

echo "📤 Enviando arquivos da API para o Databricks..."
databricks fs cp \
  output/docker_elt/api/ \
  ${DATABRICKS_BASE_PATH}/api/ \
  --recursive

echo "✅ API carregada com sucesso!"
echo "----------------------------------------------"

echo "🎉 Processo de EL finalizado com sucesso!"
