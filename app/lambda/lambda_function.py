import json
import boto3
import pymysql
import os

# Configurações do banco de dados
DB_USER = os.environ["DB_USER"]
DB_PASSWORD = os.environ["DB_PASSWORD"]
DB_NAME = os.environ["DB_NAME"]

def lambda_handler(event, context):
    # Garantir que a tabela exista
    ensure_table_exists()

    print("Event Received:", json.dumps(event, indent=2))

    # Inicialize o cliente S3
    s3_client = boto3.client("s3")

    # Processar cada mensagem
    for record in event["Records"]:
        try:
            # Decodificar mensagem do SQS
            message_body = json.loads(record["body"])
            s3_event = message_body["Records"][0]

            s3_bucket = s3_event["s3"]["bucket"]["name"]
            s3_object_key = s3_event["s3"]["object"]["key"]

            print(f"Processing file {s3_object_key} from bucket {s3_bucket}.")

            # Baixar o arquivo do S3
            local_file_path = f"/tmp/{os.path.basename(s3_object_key)}"
            s3_client.download_file(s3_bucket, s3_object_key, local_file_path)

            # Contar linhas do arquivo
            num_lines = count_lines(local_file_path)
            print(f"File {s3_object_key} has {num_lines} lines.")

            # Inserir no banco de dados
            insert_into_db(s3_object_key, num_lines)

        except Exception as e:
            print(f"Erro ao processar a mensagem: {e}")

    return {"statusCode": 200, "body": "Messages processed successfully"}

def ensure_table_exists():
    """
    Garante que a tabela 'files' exista no banco de dados.
    """
    connection = pymysql.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )
    try:
        with connection.cursor() as cursor:
            create_table_sql = """
            CREATE TABLE IF NOT EXISTS files (
                id INT AUTO_INCREMENT PRIMARY KEY,
                file_name VARCHAR(255) NOT NULL,
                num_lines INT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """
            cursor.execute(create_table_sql)
            connection.commit()
            print("Tabela 'files' verificada/criada com sucesso.")
    except Exception as e:
        print(f"Erro ao criar/verificar a tabela: {e}")
    finally:
        connection.close()

def count_lines(file_path):
    """
    Conta o número de linhas no arquivo.
    """
    with open(file_path, "r") as file:
        lines = file.readlines()
    return len(lines)

def insert_into_db(file_name, num_lines):
    """
    Insere os dados no banco de dados.
    """
    connection = pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )
    try:
        with connection.cursor() as cursor:
            sql = "INSERT INTO files (file_name, num_lines) VALUES (%s, %s)"
            cursor.execute(sql, (file_name, num_lines))
            connection.commit()
            print(f"Dados inseridos no banco: {file_name}, {num_lines}")
    except Exception as e:
        print(f"Erro ao inserir no banco de dados: {e}")
    finally:
        connection.close()
