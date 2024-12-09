import json
import boto3
import os

def lambda_handler(event, context):
    """
    Processa mensagens da SQS, que contêm informações sobre eventos do S3.
    """
    print("Event Received:", json.dumps(event, indent=2))

    # Inicialize o cliente S3
    s3_client = boto3.client("s3")

    # Variáveis de ambiente
    bucket_name = os.environ.get("BUCKET_NAME")

    # Processar cada registro de mensagem da SQS
    for record in event.get("Records", []):
        # A mensagem da SQS está no corpo
        try:
            message_body = json.loads(record["body"])  # Decodificar mensagem da SQS
            s3_event = message_body["Records"][0]  # Pega o evento do S3
        except (KeyError, json.JSONDecodeError):
            print("Erro ao processar a mensagem:", record["body"])
            continue

        # Extrair informações do evento do S3
        s3_bucket = s3_event["s3"]["bucket"]["name"]
        s3_object_key = s3_event["s3"]["object"]["key"]

        print(f"File {s3_object_key} was uploaded to bucket {s3_bucket}.")

        # Faz o download do arquivo do S3
        local_file_path = f"/tmp/{os.path.basename(s3_object_key)}"
        s3_client.download_file(s3_bucket, s3_object_key, local_file_path)

        # Processa o arquivo - Exemplo: Contar linhas
        num_lines = count_lines(local_file_path)

        # Exemplo de ação: Grava as informações em logs
        print(f"File {s3_object_key} has {num_lines} lines.")

    return {
        "statusCode": 200,
        "body": "Messages processed successfully"
    }

def count_lines(file_path):
    """
    Conta o número de linhas em um arquivo de texto.
    """
    with open(file_path, "r") as file:
        lines = file.readlines()
    return len(lines)
