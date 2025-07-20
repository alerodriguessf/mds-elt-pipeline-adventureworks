
# 🚀 Pipeline de Transformação de Dados — Lighthouse Checkpoint 3

## 1. Visão Geral do Projeto

Este projeto consolida os desafios **Lighthouse Checkpoint 2 e 3** da Indicium, implementando uma **pipeline de dados completa e moderna**. A solução abrange desde a ingestão de dados de múltiplas fontes até sua transformação e disponibilização para análise em uma arquitetura **Lakehouse**.

A pipeline realiza a ingestão de dados de um **banco de dados relacional (MSSQL)** e de uma **API REST** utilizando uma stack conteinerizada com **Meltano e Docker**. Posteriormente, esses dados são transformados, modelados e orquestrados no **Databricks** com **dbt (Data Build Tool)**, seguindo as melhores práticas de engenharia de dados.

O objetivo final é entregar um ecossistema de dados **confiável, modular, escalável e automatizado**, pronto para suportar análises de negócio complexas.

---

## 2. Arquitetura da Solução

A arquitetura foi desenhada para ser desacoplada e robusta, dividindo o fluxo de dados em etapas claras e gerenciáveis.

1.  **Extração e Carga (EL):** O **Meltano**, orquestrado dentro de um contêiner **Docker**, extrai dados das fontes (MSSQL e API). Os dados são materializados como arquivos **Parquet**.
2.  **Upload para o Lakehouse:** O **Databricks CLI**, também no contêiner, carrega os arquivos Parquet para o Databricks File System (DBFS).
3.  **Camada Bronze:** Notebooks no Databricks convertem os dados Parquet para o formato **Delta Lake**, criando as tabelas da camada Bronze e garantindo transações ACID, versionamento e performance.
4.  **Camadas Silver e Gold (T):** O **dbt** assume o controle para executar as transformações. Ele lê os dados da camada Bronze e aplica regras de negócio, limpeza e modelagem dimensional (Kimball) para criar as camadas Silver (staging) e Gold (marts).
5.  **Orquestração:** O **Databricks Workflows** automatiza todo o processo, desde a conversão para Delta até a execução dos modelos dbt, garantindo que os dados sejam atualizados de forma agendada e confiável.

### 🔧 Componentes Técnicos

| Componente | Papel na Pipeline | Etapa |
| :--- | :--- | :--- |
| `Meltano` | Extrai dados de fontes diversas com seus conectores (`taps`) | Ingestão |
| `Docker` | Cria ambiente de ingestão reprodutível e isolado | Ingestão |
| `Target Parquet` | Armazena dados extraídos em formato colunar otimizado | Ingestão |
| `Databricks CLI` | Faz o upload dos dados brutos para o Lakehouse | Ingestão |
| `Databricks Notebooks` | Converte Parquet em tabelas Delta (Camada Bronze) | Orquestração |
| `dbt (Data Build Tool)` | Orquestra, testa e documenta as transformações SQL | Transformação |
| `Delta Lake` | Garante governança, performance e confiabilidade aos dados | Todas |
| `Databricks Workflows`| Agenda e executa a pipeline completa de forma automatizada | Orquestração |

---

## 3. Configuração e Execução

Para executar a pipeline completa localmente, siga as etapas abaixo.

### 3.1 Pré-requisitos

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v4.x+)
* [Git](https://git-scm.com/)
* [Python 3.10 ou 3.11](https://www.python.org/) e `pip`
* Acesso a um workspace **Databricks** (Community Edition ou superior)
* Credenciais para o banco **MSSQL** e para a **API REST**

### 3.2 Clonar o Repositório

```bash
git clone [https://github.com/alerodriguessf/lighthouse_desafio03_alexandrersf](https://github.com/alerodriguessf/lighthouse_desafio03_alexandrersf)
cd lighthouse_desafio03_alexandrersf
````

### 3.3 Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto a partir do modelo `.env.save`. Este arquivo centraliza todas as credenciais e configurações.

```env
# CREDENCIAIS DE INGESTÃO (CHECKPOINT 2)
# MSSQL
TAP_MSSQL_HOST=your_mssql_host
TAP_MSSQL_PORT=1433
TAP_MSSQL_USER=your_user
TAP_MSSQL_PASSWORD=your_password
TAP_MSSQL_DATABASE=AdventureWorks2022

# API
API_HOST=[https://your-api-url.com](https://your-api-url.com)
API_USER=your_api_user
API_PASSWORD=your_api_password

# CREDENCIAIS DO DATABRICKS (PARA INGESTÃO E DBT)
DATABRICKS_HOST=[https://your-databricks-instance.cloud.databricks.com](https://your-databricks-instance.cloud.databricks.com)
DATABRICKS_TOKEN=your_pat_token
```

> 🔐 **Importante**: Não versione este arquivo com Git. Ele já está incluído no `.gitignore`.

### 3.4 Etapa 1: Ingestão de Dados (Meltano & Docker)

Esta etapa extrai os dados das fontes e os carrega como arquivos Parquet no Databricks.

**1. Construir a Imagem Docker:**

```bash
docker build -t lighthouse-ingestion-pipeline .
```

**2. Executar o Contêiner de Ingestão:**

```bash
docker run --env-file .env lighthouse-ingestion-pipeline
```

Este comando executa o script `entrypoint.sh`, que realiza a extração via Meltano e o upload dos arquivos `.parquet` para o DBFS.

### 3.5 Etapa 2: Transformação de Dados (dbt)

Com os dados brutos no Databricks, esta etapa executa as transformações para criar os modelos analíticos.

**1. Criar o Ambiente Virtual:**

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
# ou
venv\Scripts\activate     # Windows
```

**2. Instalar as Dependências:**

```bash
pip install -r requirements.txt
```

**3. Configurar o Profile do dbt:**
Crie o arquivo `~/.dbt/profiles.yml` com suas credenciais do Databricks. O dbt o utilizará para se conectar ao seu workspace.

```yaml
dbt_checkpoint3_dw:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: ted_dev
      schema: silver
      host: <seu-databricks-host> # Ex: [https://adb-....cloud.databricks.com](https://adb-....cloud.databricks.com)
      http_path: /sql/1.0/warehouses/<seu-warehouse-id>
      token: <seu-personal-access-token>
```

**4. Executar os Comandos dbt:**

```bash
# Instalar dependências do projeto dbt (se houver)
dbt deps

# Executar os modelos (camadas Bronze -> Silver -> Gold)
dbt run

# Rodar os testes de qualidade de dados
dbt test

# Gerar e servir a documentação localmente
dbt docs generate
dbt docs serve
```

-----

## 4\. Organização e Modelagem no DBT

A modelagem dos dados foi implementada utilizando o dbt com base na arquitetura em camadas (staging e marts), alinhada às boas práticas de engenharia de dados e modelagem dimensional.

> A documentação completa e navegável dos modelos DBT pode ser consultada online:
> **[https://checkpoint3-alexandrersf.netlify.app/\#\!/overview](https://checkpoint3-alexandrersf.netlify.app/#!/overview)**

### 4.1 Estrutura dos diretórios

```
models/
├── staging/            # Limpeza, padronização e normalização
│   ├── stg_sales_order_header.sql
│   └── ...
├── marts/              # Modelos de negócio (dimensões e fatos)
│   ├── dim_product.sql
│   ├── fact_sales_order.sql
│   └── ...
```

  * **Staging (Camada Silver):** Isola transformações iniciais, aplica casting, uniformiza nomes e lida com inconsistências.
  * **Marts (Camada Gold):** Representa os modelos analíticos, contendo as tabelas fato e dimensões prontas para consumo.

### 4.2 Testes e Validações

Os arquivos `schema.yml` em cada diretório contêm testes de integridade (`not_null`, `unique`, `relationships`), documentação de colunas e tags para organização das execuções.

-----

## 5. Orquestração e Reprodutibilidade com Databricks Workflows

A automação da pipeline é gerenciada pelo **Databricks Workflows**, garantindo que os dados sejam processados de forma agendada, confiável e na ordem correta. Toda a configuração do workflow está definida de forma declarativa no arquivo `databricks_pipeline.yml`, localizado na raiz deste repositório.

Essa abordagem permite que a orquestração seja versionada junto com o código e facilmente replicada.

### 5.1 Estrutura e Dependências do Workflow

O workflow é composto por tarefas que executam notebooks e o pipeline dbt. As dependências entre elas garantem a integridade do fluxo de ponta a ponta.

| Chave da Tarefa | Tipo de Tarefa | Descrição |
| :--- | :--- | :--- |
| `delta_conversion_api` | Notebook | Executa o script em `/scripts_aux/` para converter os dados da API (Parquet) em tabelas Delta na camada Bronze. |
| `delta_conversion_sqlserver` | Notebook | Executa o script em `/scripts_aux/` para converter os dados do SQL Server (Parquet) para o formato Delta. |
| `dbt_run` | Tarefa DBT | Após a conclusão das conversões, executa `dbt deps` e `dbt run` para atualizar as camadas Silver e Gold. |

A sequência de execução é a seguinte:

```
[delta_conversion_api]       ─┐
                               ├──>  [dbt_run]
[delta_conversion_sqlserver] ┘
```

### 5.2 Como Implantar o Workflow no Databricks

Em vez de usar a CLI, você pode criar o job diretamente na interface do Databricks de forma simples:

1.  **Acesse o seu Workspace Databricks** e navegue até a seção **Workflows**.
2.  Clique no botão **Create Job**.
3.  Dê um nome ao seu Job (ex: `lighthouse_pipeline_dbt`).
4.  Na tela de configuração da primeira tarefa, procure e clique na opção **Edit YAML**.
5.  **Abra o arquivo `databricks_pipeline.yml`** que está na raiz do repositório em sua máquina local.
6.  **Copie todo o conteúdo** do arquivo.
7.  **Cole o conteúdo** no editor YAML dentro do Databricks.
8.  Clique em **Save**.

Pronto\! O seu workflow será criado com todas as tarefas, dependências e configurações definidas no arquivo. Agora você pode executá-lo manualmente ou aguardar a execução agendada.

-----

## 6\. Documentação, Visualização e Entregáveis

### 6.1 Documentação Técnica (dbt Docs)

Todos os modelos, colunas e fontes foram documentados. A documentação interativa, com linhagem de dados e descrições, está publicada e pode ser acessada publicamente.

🔗 **[Acesse a documentação dbt](https://checkpoint3-alexandrersf.netlify.app/#!/overview)**

### 6.2 Entregáveis do Projeto

| Item | Status | Localização / Artefato |
| :--- | :--- | :--- |
| Pipeline de ingestão (Meltano) | ✅ Concluído | `Dockerfile`, `entrypoint.sh`, `meltano.yml` |
| Conversão para Delta Lake | ✅ Concluído | Notebooks Databricks em `/scripts_aux/` |
| Projeto `dbt` com testes | ✅ Concluído | Diretório `/models`, `dbt_project.yml`, `schema.yml` |
| Orquestração no Databricks | ✅ Concluído | Arquivo YAML versionado com a definição do Job |
| Documentação dbt navegável | ✅ Publicado | [checkpoint3-alexandrersf.netlify.app](https://checkpoint3-alexandrersf.netlify.app/#!/overview) |

-----

## 7\. Contato e Créditos

Este projeto foi desenvolvido por **Alexandre R. Silva Filho** como parte do programa **Lighthouse** da [link suspeito removido].

  * **Email:** [alexandre.filho@indicium.tech](mailto:alexandre.filho@indicium.tech)
  * **LinkedIn:** [https://www.linkedin.com/in/alerodriguessf](https://www.linkedin.com/in/alerodriguessf/)
  * **GitHub:** [github.com/alerodriguessf](https://github.com/alerodriguessf)

<!-- end list -->
