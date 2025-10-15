
# 🚀 Data Transformation Pipeline — Lighthouse Checkpoint 3

## 1. Project Overview

This project implements a **modern end-to-end data pipeline**. The solution encompasses the entire flow, from data ingestion to transformation and analysis availability within a **Lakehouse architecture**.

The pipeline ingests data from both a **relational database (MSSQL)** and a **REST API**, using a containerized stack built with **Meltano and Docker**. Once ingested, data is transformed, modeled, and orchestrated in **Databricks** using **dbt (Data Build Tool)**, adhering to data engineering best practices.

The final goal is to deliver a **reliable, modular, scalable, and automated** data ecosystem, ready to support complex business analytics.

---

## 2. Solution Architecture

The architecture was designed to be decoupled and robust, splitting the flow into clear and manageable stages.

1. **Extract & Load (EL):** **Meltano**, orchestrated inside a **Docker** container, extracts data from MSSQL and the API. Data is materialized as **Parquet files**.
2. **Upload to Lakehouse:** The **Databricks CLI** uploads the Parquet files into the Databricks File System (DBFS).
3. **Bronze Layer:** Databricks Notebooks convert Parquet files into **Delta Lake** tables, ensuring ACID transactions, versioning, and performance.
4. **Silver & Gold Layers (T):** **dbt** takes over transformation, applying cleaning, business logic, and dimensional modeling to create Silver (staging) and Gold (marts) layers.
5. **Orchestration:** **Databricks Jobs & Pipelines** automate the entire process, from Parquet-to-Delta conversion to dbt model execution, ensuring reliable and scheduled updates.

### 🔧 Tech Stack

| Component | Role in Pipeline | Stage |
| :--- | :--- | :--- |
| `Meltano` | Extracts data from diverse sources via connectors (`taps`) | Ingestion |
| `Docker` | Provides reproducible and isolated ingestion environment | Ingestion |
| `Target Parquet` | Stores raw extracted data in optimized columnar format | Ingestion |
| `Databricks CLI` | Uploads raw data to Lakehouse | Ingestion |
| `Databricks Notebooks` | Converts Parquet into Delta tables (Bronze Layer) | Orchestration |
| `dbt (Data Build Tool)` | Runs, tests, and documents SQL transformations | Transformation |
| `Delta Lake` | Provides governance, reliability, and high performance | All |
| `Databricks Jobs & Pipelines` | Automates pipeline execution end-to-end | Orchestration |

---

## 3. Setup & Execution

### 3.1 Requirements

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (v4.x+)
* [Git](https://git-scm.com/)
* [Python 3.10 or 3.11](https://www.python.org/) with `pip`
* Access to a **Databricks workspace** (Free Edition or higher)
* Credentials for **MSSQL** and the **REST API**

### 3.2 Clone the Repository

```bash
git clone https://github.com/alerodriguessf/lighthouse_desafio03_alexandrersf
cd lighthouse_desafio03_alexandrersf
````

### 3.3 Virtual Environment & Dependencies

**1. Create virtual environment:**

```bash
python -m venv venv
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate     # Windows
```

**2. Install dependencies:**

```bash
pip install -r requirements.txt
```

### 3.4 Credentials Setup

**1. Environment variables (`.env`):**

Create a `.env` file in the project root from the template `.env.save`. It stores all credentials needed for ingestion with Docker and Meltano.

```env
# INGESTION CREDENTIALS
# MSSQL
TAP_MSSQL_HOST=your_mssql_host
TAP_MSSQL_PORT=1433
TAP_MSSQL_USER=your_user
TAP_MSSQL_PASSWORD=your_password
TAP_MSSQL_DATABASE=AdventureWorks2022

# API
API_HOST=https://your-api-url.com
API_USER=your_api_user
API_PASSWORD=your_api_password

# DATABRICKS CREDENTIALS
DATABRICKS_HOST=https://your-databricks-instance.cloud.databricks.com
DATABRICKS_TOKEN=your_pat_token
```

> 🔐 **Important:** Do not commit this file to Git. It is already listed in `.gitignore`.

**2. dbt Profile (`profiles.yml`):**

```yaml
dbt_checkpoint3_dw:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: ted_dev
      schema: silver
      host: <your-databricks-host>
      http_path: /sql/1.0/warehouses/<your-warehouse-id>
      token: <your-personal-access-token>
```

### 3.5 Run the Pipeline

**Step 1: Data Ingestion (Meltano & Docker)**

```bash
docker build -t lighthouse-ingestion-pipeline .
docker run --env-file .env lighthouse-ingestion-pipeline
```

**Step 2: Data Transformation (dbt)**

```bash
dbt deps
dbt run
dbt test
dbt docs generate
dbt docs serve
```

---

## 4. dbt Modeling & Structure

Data modeling follows a layered architecture aligned with dimensional modeling best practices.

📄 **Full interactive dbt docs:**
👉 [checkpoint3-alexandrersf.netlify.app](https://checkpoint3-alexandrersf.netlify.app/#!/overview)

**Project structure:**

```
models/
├── staging/       # Silver layer (cleaning, normalization)
├── marts/         # Gold layer (business-ready facts & dimensions)
```

* **Staging (Silver):** Handles casting, normalization, and cleanup.
* **Marts (Gold):** Business-ready fact and dimension models.

---

## 5. Orchestration with Databricks Jobs & Pipelines

Automation is handled by **Databricks Jobs & Pipelines**, defined declaratively in `databricks_pipeline.yml`.

**Execution order:**

```
[delta_conversion_api] ─┐
                        ├──> [dbt_run]
[delta_conversion_sqlserver] ┘
```

Steps to deploy in Databricks UI:

1. Go to **Jobs & Pipelines** → **Create Job**.
2. Edit YAML.
3. Paste contents of `databricks_pipeline.yml`.
4. Save & run.

---

## 6. Documentation & Deliverables

* 📊 **dbt Documentation:** [checkpoint3-alexandrersf.netlify.app](https://checkpoint3-alexandrersf.netlify.app/#!/overview)
* ✅ Ingestion Pipeline (Meltano)
* ✅ Delta Conversion (Databricks Notebooks)
* ✅ dbt Project with Tests
* ✅ Orchestration (Databricks Jobs & Pipelines)
* ✅ Published dbt Docs

---

## 7. Contact

Project developed by **Alexandre R. Silva Filho**.

* **Email:** [alerodriguessf@gmail.com](mailto:alerodriguessf@gmail.com)
* **LinkedIn:** [linkedin.com/in/alerodriguessf](https://www.linkedin.com/in/alexandrersf/)
* **GitHub:** [github.com/alerodriguessf](https://github.com/alerodriguessf)

```
