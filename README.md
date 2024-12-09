## Plano de Desenvolvimento

### 1. Arquitetura

A solução será desenvolvida pelos seguintes componentes:

- S3: Armazenamento dos arquivos.
- SNS: Notificação de eventos no S3.
- SQS: Fila para processar mensagens vindas do SNS.
- Lambda: Função que lê mensagens do SQS, processa os dados e registra no banco.
- RDS: Cache para melhorar a leitura de dados frequentemente consultados.
- Banco de Dados: MySQL ou PostgreSQL (compatível com AWS RDS).

### 2. Fluxo de Trabalho

- Um script gera um arquivo com um número aleatório de linhas.
- O arquivo é enviado automaticamente para o S3.
- Um evento do S3 dispara uma notificação para o SNS.
- SNS encaminha a notificação para o SQS.
- Uma Lambda é acionada para:
  - Ler a mensagem do SQS.
  - Processar o arquivo (contar as linhas).
  - Registrar os dados (nome do arquivo e quantidade de linhas) no banco de dados.
- Banco de dados mysql para armazernar os dados.

### 3. Requisitos Técnicos

- Aplicação para geração e envio
  - Linguagem: Python.
  - Uso da biblioteca boto3 para integração com o AWS S3.
  - Geração de arquivos com uuid para nomes únicos.
- Código da infraestrutura
  - Terraform para provisionar os recursos AWS (S3, SNS, SQS, Lambda, e RDS).
