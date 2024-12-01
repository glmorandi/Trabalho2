
# **Sistema com CI/CD e Migração Automatizada**

  

Este repositório implementa um sistema de CI/CD que gerencia duas pipelines distintas para as branches `main` e `develop`. Ele utiliza **GitHub Actions** para deploy automatizado de um site estático (hospedado no GitHub Pages) e para executar migrações de banco de dados (hospedado no **Supabase**).

  

---

  

## **Visão Geral do Projeto**

  

### Funcionalidades:

1.  **Deploy Automático do Frontend**:

- Hospedagem no **GitHub Pages**.

- Dois ambientes:

-  **`develop`**: Atualiza após cada merge na branch `develop`.

-  **`main`**: Atualiza diariamente às 21:00.

  

2.  **Migrações de Banco de Dados**:

- Gerenciadas por um único arquivo: `migrate.sql`.

- Incremento automático de versão no banco, sem necessidade de editar o arquivo para novas migrações.

- Dois bancos separados:

-  **`develop`**: Banco de desenvolvimento.

-  **`main`**: Banco de produção.

  

---

  

## **Estrutura do Repositório**

  

```plaintext

- index.html # Página estática (site fictício)

- migrations/

	- migrate.sql # Arquivo unificado para migrações

- .github/

	- workflows/

		- develop.yml # Pipeline para branch develop

		- main.yml # Pipeline para branch main

- README.md # Documentação do projeto

```

  

---

  

## **Pipelines do GitHub Actions**

  

### **Pipeline para `develop`**

- Gatilho: Toda vez que um Pull Request for mergeado na branch `develop`.

- Etapas:

1. Publica o site no GitHub Pages (`/dev`).

2. Atualiza o banco de dados de desenvolvimento no Supabase.

  

### **Pipeline para `main`**

- Gatilho: Atualização diária agendada às 21:00.

- Etapas:

1. Publica o site no GitHub Pages.

2. Atualiza o banco de dados de produção no Supabase.

  

---

  

## **Migrações de Banco de Dados**

  

As migrações são gerenciadas pelo arquivo único `migrate.sql`. Ele incrementa automaticamente a versão da migração e registra no banco de dados.

  

**Exemplo do Arquivo `migrate.sql`:**

```sql
-- Cria a tabela de controle de migrações, se ainda não existir.

CREATE  TABLE  IF  NOT  EXISTS migrations_log (

id SERIAL  PRIMARY KEY,

migration_version INT  NOT NULL  UNIQUE,

executed_at TIMESTAMP  DEFAULT  NOW()

);

-- Determina a próxima versão da migração.

DO $$

DECLARE

current_version INT;

next_version INT;

BEGIN

-- Obtém a versão mais recente do log ou assume 0 se não houver nenhuma.

SELECT  COALESCE(MAX(migration_version), 0) INTO current_version FROM migrations_log;

-- Define a próxima versão (incrementa o valor atual em 1).

next_version := current_version + 1;

-- Insere o novo número da migração no log.

INSERT INTO migrations_log (migration_version) VALUES (next_version);

RAISE NOTICE 'Migration % has been applied at %', next_version, NOW();

END $$;

```

## **Configuração**

  

### **1. Supabase**

Crie dois projetos no Supabase, um para cada ambiente (`develop` e `main`).

  

### **2. Secrets do GitHub Actions**

Adicione os seguintes secrets no repositório do GitHub:

  
| Nome | Descrição |
|--|--|
| `SUPABASE_URL_DEV` | URL do banco de desenvolvimento |
| `SUPABASE_KEY_DEV` | Senha do usuário do banco de desenvolvimento |
| `SUPABASE_USER_DEV` | Usuário do banco de desenvolvimento |


  

### **3. Variáveis de Configuração**

Certifique-se de que os arquivos YAML dos workflows (`develop.yml` e `main.yml`) estejam configurados corretamente para os dois ambientes.

  

---

  

## **Como o Processo Funciona**

  

### **Branch `develop`**

1. Ao fazer merge em `develop`:

- O site é publicado no GitHub Pages (`/dev`).

- O arquivo `migrate.sql` é executado no banco de desenvolvimento.

  

### **Branch `main`**

1. Diariamente às 21:00:

- O site é publicado no GitHub Pages.

- O arquivo `migrate.sql` é executado no banco de produção.
