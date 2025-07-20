# 🚀 Pipeline de Transformação de Dados — Lighthouse Checkpoint 3

## 1. Visão Geral do Projeto

Este projeto foi desenvolvido como parte do desafio **Lighthouse Checkpoint 3** da Indicium, com o objetivo de construir uma arquitetura analítica moderna, baseada no paradigma **Lakehouse** e nas boas práticas de engenharia e modelagem de dados.

A proposta consiste na ingestão, transformação e organização de dados oriundos de múltiplas fontes — uma API REST e um banco de dados SQL Server — utilizando ferramentas robustas e amplamente adotadas pelo mercado:

- **Databricks** como motor analítico e plataforma unificada de dados
- **dbt (Data Build Tool)** para orquestração e versionamento das transformações
- **Delta Lake** para garantir escalabilidade, performance e governança dos dados
- **Databricks Workflows** para orquestração e agendamento automatizado da pipeline

A arquitetura foi concebida para refletir os princípios de **modularidade, reprodutibilidade, testes, versionamento e documentação**, facilitando tanto o desenvolvimento colaborativo quanto a manutenção em produção.

---

## 2. Objetivos Técnicos

- ✅ Construir um pipeline de dados escalável utilizando **Databricks Lakehouse** e **Delta Lake**
- ✅ Realizar ingestão de múltiplas fontes de dados (SQL Server e API REST)
- ✅ Implementar uma modelagem dimensional baseada no framework **Kimball**
- ✅ Organizar os dados em camadas **Bronze**, **Silver** e **Gold**
- ✅ Aplicar boas práticas de desenvolvimento com **dbt** (modularização, testes, documentação)
- ✅ Criar **dimensões** e **fatos** com foco em análise de vendas e performance
- ✅ Agendar a execução automatizada da pipeline com **Databricks Workflows (Jobs YAML)**
- ✅ Gerar documentação navegável e autoatualizável com `dbt docs`

---

## 3. Instruções de Execução Local

### 3.1 Pré-requisitos

Para executar este projeto localmente, você precisará dos seguintes itens instalados:

- [Python 3.10 ou 3.11](https://www.python.org/)
- [pip](https://pip.pypa.io/)
- [dbt-databricks](https://docs.getdbt.com/reference/warehouse-profiles/databricks-profile)
- [Git](https://git-scm.com/)
- Conta gratuita no [Databricks Community Edition](https://community.cloud.databricks.com/) com um Warehouse Serverless (Starter Warehouse)

---

### 3.2 Clonando o Repositório

```bash
git clone https://github.com/alerodriguessf/lighthouse_desafio03_alexandrersf
cd lighthouse_desafio03_alexandrersf
````

---

### 3.3 Criando o Ambiente Virtual

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

---

### 3.4 Instalando as Dependências

```bash
pip install -r requirements.txt
```

> O arquivo `requirements.txt` contém as dependências essenciais, incluindo:
>
> * `dbt-databricks`
> * `pyspark`
> * `pydantic` (compatível com dbt >= 1.10)

---

### 3.5 Configurando o Profile do dbt

Crie o arquivo de perfil do dbt em `~/.dbt/profiles.yml` com as suas credenciais do Databricks:

```yaml
dbt_checkpoint3_dw:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: ted_dev
      schema: silver
      host: https://<sua-instancia>.cloud.databricks.com
      http_path: /sql/1.0/warehouses/<seu-warehouse-id>
      token: <seu-personal-access-token>
```

> Substitua os campos `<...>` pelas informações da sua instância Databricks.
> Você pode encontrar o `http_path` e o `token` na interface web do Databricks.

---

### 3.6 Executando os Comandos dbt

Com o ambiente ativado e o profile configurado, você pode executar os seguintes comandos:

#### Instalar dependências do projeto:

```bash
dbt deps
```

#### Compilar e executar os modelos:

```bash
dbt run
```

#### Rodar os testes de qualidade de dados:

```bash
dbt test
```

#### Gerar a documentação navegável:

```bash
dbt docs generate
dbt docs serve
```

> A documentação será aberta automaticamente no seu navegador em `http://localhost:8000`.

---

### ✔️ Pronto!

Se todos os passos forem seguidos corretamente, o dbt executará as transformações e criará as tabelas `staging`, `dimensions` e `facts` no seu ambiente Databricks.


Perfeito! Com base na estrutura visual do projeto DBT que você compartilhou (imagem `estrutura dbt.png`), nos requisitos do desafio e no histórico do checkpoint 2, aqui está a próxima seção detalhada em Markdown para o seu `README.md`:

---

Claro! Aqui está a **revisão da seção 3. Organização e Modelagem no DBT**, alinhada com a estrutura, tom e rigor técnico estabelecidos na seção anterior (3.6). Essa versão evita exageros nos emojis, mantém uma linguagem clara e profissional, e segue uma estrutura coesa com o restante do `README.md`.

---

## 3. Organização e Modelagem no DBT

A modelagem dos dados foi implementada utilizando o [dbt (data build tool)](https://www.getdbt.com/), com base na arquitetura em camadas (staging e marts), alinhada às boas práticas de engenharia de dados e modelagem dimensional. Essa separação permite maior controle, reusabilidade e governança dos dados transformados.

> A documentação completa dos modelos DBT pode ser consultada online:
> [https://checkpoint3-alexandrersf.netlify.app/#!/overview](https://checkpoint3-alexandrersf.netlify.app/#!/overview)

### 3.1 Estrutura dos diretórios

A estrutura dos modelos no projeto segue a convenção recomendada pelo dbt, dividida em duas camadas principais:

```
models/
├── staging/
│   ├── stg_sales_order_header.sql
│   ├── stg_sales_order_detail.sql
│   ├── stg_sales_customer_info.sql
│   ├── ...
│   └── schema.yml
├── marts/
│   ├── dim_date.sql
│   ├── dim_product.sql
│   ├── fact_sales_order.sql
│   ├── fact_sales_summary_monthly.sql
│   ├── ...
│   └── schema.yml
```

* **Staging**: responsável por tratamentos leves, normalização, padronização de tipos e nomenclaturas.
* **Marts**: representa os modelos analíticos, contendo as tabelas fato e dimensões consumidas em análises.

### 3.2 Modelos de Staging

Os modelos de staging têm como função:

* Isolar transformações iniciais
* Aplicar *casting* de tipos de dados
* Uniformizar nomes de colunas
* Lidar com dados nulos e inconsistências

Exemplos:

* `stg_sales_order_header.sql`
* `stg_sales_order_detail.sql`
* `stg_sales_person_details.sql`
* `stg_sales_ship_method.sql`

Cada um desses modelos se conecta diretamente às tabelas Delta da camada Bronze do Databricks.

### 3.3 Modelos de Marts

Os modelos da camada marts realizam agregações, junções e enriquecimentos dos dados, sendo organizados em:

* **Tabelas Fato**:

  * `fact_sales_order.sql`: granularidade ao nível de item de pedido
  * `fact_sales_summary_monthly.sql`: resumo mensal de vendas por cliente e vendedor

* **Tabelas Dimensão**:

  * `dim_date.sql`: calendário base para análises temporais
  * `dim_product.sql`: metadados de produtos
  * `dim_customer.sql`: identificação de clientes
  * `dim_salesperson.sql`: equipe comercial
  * `dim_ship_method.sql`: métodos de envio

### 3.4 Testes e validações

Os arquivos `schema.yml` em cada camada contêm:

* Testes de integridade: `not_null`, `unique`, `relationships`
* Documentação de colunas e modelos
* Tags para facilitar a organização de execuções no CI/CD

Exemplo de teste implementado:

```yaml
- name: dim_product
  description: "Dimensão de produtos com enriquecimento"
  tests:
    - unique:
        column_name: product_id
    - not_null:
        column_name: product_id
```

### 3.5 Geração e publicação da documentação

A documentação dos modelos foi gerada com:

```bash
dbt docs generate
```

E publicada utilizando o Netlify, permitindo navegação interativa entre tabelas, colunas, dependências e descrições.

Link público: [checkpoint3-alexandrersf.netlify.app](https://checkpoint3-alexandrersf.netlify.app/#!/overview)

### 3.6 Execução dos modelos DBT

A execução local dos modelos pode ser feita com os seguintes comandos:

```bash
# Instalar dependências
dbt deps

# Executar todos os modelos
dbt run

# Executar apenas os modelos da camada mart
dbt run --select marts

# Gerar documentação
dbt docs generate

# Abrir visualmente a documentação local
dbt docs serve
```

> Obs.: O projeto está integrado à orquestração Databricks, e os comandos `dbt deps` e `dbt run` são acionados automaticamente via pipeline.

---

Perfeito. Com base no YAML do pipeline que você forneceu, na estrutura do projeto e nas boas práticas de orquestração com Databricks, aqui está a **Seção 4 – Orquestração no Databricks**, escrita em Markdown e com linguagem alinhada às seções anteriores do `README.md`.

---

## 4. Orquestração no Databricks

Para garantir reprodutibilidade, modularidade e automação, a pipeline foi orquestrada diretamente no **Databricks Workflows**, utilizando uma definição YAML compatível com a estrutura declarativa do Databricks CLI v2.

A orquestração contempla as etapas críticas da transformação de dados no Lakehouse:

1. Conversão dos arquivos Parquet da API e SQL Server para tabelas Delta (camada Bronze)
2. Execução do pipeline dbt (staging e marts)
3. Parametrização flexível via variáveis de ambiente

### 4.1 Estrutura geral do pipeline

O workflow é composto por **três tarefas principais**:

| Task Key                     | Tipo     | Descrição                                                               |
| ---------------------------- | -------- | ----------------------------------------------------------------------- |
| `delta_conversion_api`       | Notebook | Converte os arquivos `.parquet` da API em tabelas Delta (camada Bronze) |
| `delta_conversion_sqlserver` | Notebook | Converte os arquivos do SQL Server em Delta                             |
| `dbt_run`                    | DBT Task | Executa o pipeline dbt após a conversão das tabelas                     |

### 4.2 Hierarquia e dependências

O pipeline é executado diariamente e segue a seguinte ordem de execução:

```
delta_conversion_api          ─┐
                              ├──>  dbt_run
delta_conversion_sqlserver    ┘
```

Essa estrutura garante que o pipeline dbt só seja executado após a ingestão e conversão completa dos dados em Delta Lake.

### 4.3 Parâmetros e ambientes

O pipeline utiliza **parâmetros externos** para permitir reuso em diferentes ambientes e catálogos:

```yaml
parameters:
  - name: DATABRICKS_CATALOG
    default: ted_dev
  - name: DATABRICKS_SCHEMA_RAW
    default: bronze
  - name: DATABRICKS_SCHEMA_STAGING
    default: silver
  - name: DATABRICKS_SCHEMA_MARTS
    default: gold
  - name: DATABRICKS_VOLUME
    default: raw
```

Além disso, foi configurado um **ambiente padrão (`dbt-default`)** com as dependências necessárias:

```yaml
environments:
  - environment_key: dbt-default
    spec:
      client: "2"
      dependencies:
        - dbt-databricks>=1.10.4
```

### 4.4 Execução de comandos dbt no Databricks

A tarefa `dbt_run` executa os seguintes comandos:

```bash
dbt deps --vars '{...}'      # Instala dependências
dbt run --vars '{...}'       # Executa todos os modelos
```

As variáveis passadas ao `--vars` são resolvidas a partir dos parâmetros definidos no job, permitindo total desacoplamento e controle da execução.

### 4.5 Versionamento e reprodutibilidade

A definição do pipeline está versionada em Git:

```yaml
git_source:
  git_url: https://github.com/alerodriguessf/lighthouse_desafio03_alexandrersf-
  git_provider: gitHub
  git_branch: databricks
```

Isso garante que cada execução do workflow esteja atrelada a um estado específico do projeto, assegurando rastreabilidade e consistência.

Perfeito! Seguindo o mesmo padrão de clareza, profundidade e consistência com as seções anteriores, aqui está a **Seção 5 – Documentação, Visualização e Entregáveis**, já em Markdown para ser colada diretamente no seu `README.md`.

---

## 5. Documentação, Visualização e Entregáveis

### 5.1 Documentação técnica (dbt Docs)

Todos os modelos desenvolvidos no `dbt` foram documentados utilizando descrições claras para tabelas e colunas, incluindo:

* Fonte dos dados (upstream)
* Lógica de transformação
* Regras de negócio aplicadas
* Dicionário de dados (coluna a coluna)

A documentação gerada pode ser acessada publicamente através do link:

🔗 **[Acesse a documentação dbt](https://checkpoint3-alexandrersf.netlify.app/#!/overview)**

Essa interface é útil para:

* Validar o fluxo de dados e dependências entre modelos (`Lineage`)
* Consultar os testes aplicados (como `not_null`, `unique`)
* Garantir a governança da informação e transparência analítica

---

### 5.2 Outputs gerados no Lakehouse

Ao final da execução da pipeline, as seguintes **camadas e tabelas** são criadas automaticamente no catálogo `ted_dev`:

#### Bronze

* `raw_api_<nome_tabela>_db`: Tabelas de origem da API REST
* `raw_sqlserver_<nome_tabela>_db`: Tabelas extraídas do banco SQL Server

#### Silver (Staging)

* Modelos intermediários com limpeza, renomeação e validação de schema, todos prefixados com `stg_`

#### Gold (Marts)

* **Dimensões:**

  * `dim_customer`
  * `dim_date`
  * `dim_product`
  * `dim_salesperson`
  * `dim_ship_method`

* **Fatos:**

  * `fact_sales_order`
  * `fact_sales_summary_monthly`
  * (Outras fatos agregadas ou snapshot podem ser adicionadas conforme necessidade analítica)

---

### 5.3 Entregáveis do Projeto

| Item                         | Status      | Localização                                                                                      |
| ---------------------------- | ----------- | ------------------------------------------------------------------------------------------------ |
| Pipeline de ingestão Meltano | ✅ Concluído | `entrypoint.sh`, `meltano.yml`, plugins e configuração `.env`                                    |
| Conversão para Delta Lake    | ✅ Concluído | Notebooks Databricks em `/scripts_aux/`                                                          |
| Projeto `dbt` com testes     | ✅ Concluído | Diretório `/models`, `dbt_project.yml`, `schema.yml`, `profiles.yml`                             |
| Orquestração no Databricks   | ✅ Concluído | Arquivo YAML versionado com definição do pipeline                                                |
| Documentação dbt             | ✅ Publicado | [checkpoint3-alexandrersf.netlify.app](https://checkpoint3-alexandrersf.netlify.app/#!/overview) |

---

### 5.4 Considerações finais

O projeto foi construído com foco em:

* Transparência e modularidade do processo analítico
* Reprodutibilidade e versionamento de ponta a ponta
* Escalabilidade para novas fontes e domínios de dados

Todos os componentes são extensíveis e podem ser facilmente adaptados para atender a novos requisitos de negócio ou expansão da arquitetura de dados.

Claro! Abaixo está a **Seção 6 – Contato e Créditos**, finalizando o seu `README.md` com clareza e profissionalismo:

---

## 6. Contato e Créditos

Este projeto foi desenvolvido por **Alexandre R. Silva Filho** como parte do programa **Lighthouse** da [Indicium Tech](https://indicium.tech), integrando conhecimentos de engenharia e modelagem de dados, orquestração de pipelines e melhores práticas em arquitetura de dados moderna.

### 👤 Autor

* **Nome:** Alexandre R. Silva Filho
* **Email:** [alexandre.filho@indicium.tech](mailto:alexandre.filho@indicium.tech)
* **LinkedIn:**[https://www.linkedin.com/in/alerodriguessf](https://www.linkedin.com/in/alexandrersf/)
* **GitHub:** [github.com/alerodriguessf](https://github.com/alerodriguessf)


### 📄 Licença

Este repositório é de uso educacional e não possui restrições de licença para reprodução pessoal ou testes. Para fins comerciais ou reuso corporativo, recomenda-se análise prévia e adaptação conforme necessidade.

---





