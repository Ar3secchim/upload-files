import json
import boto3
import os

def lambda_handler(event, context):
    """
    Processa eventos do S3, extraindo informações sobre o arquivo enviado.
    """
    print("Event Received:", json.dumps(event, indent=2))

    # Inicialize o cliente S3
    s3_client = boto3.client("s3")

    # Variáveis do ambiente
    bucket_name = os.environ.get("BUCKET_NAME")

    # Processar cada registro de evento
    for record in event.get("Records", []):
        # Extrair informações do evento
        s3_bucket = record["s3"]["bucket"]["name"]
        s3_object_key = record["s3"]["object"]["key"]

        print(f"File {s3_object_key} was uploaded to bucket {s3_bucket}.")

        # Faz o download do arquivo (se necessário)
        local_file_path = f"/tmp/{os.path.basename(s3_object_key)}"
        s3_client.download_file(s3_bucket, s3_object_key, local_file_path)

        # Processa o arquivo - Exemplo: Contar linhas
        num_lines = count_lines(local_file_path)

        # Exemplo de ação: Grava as informações em logs
        print(f"File {s3_object_key} has {num_lines} lines.")

    return {
        "statusCode": 200,
        "body": "File processed successfully"
    }


def count_lines(file_path):
    """
    Conta o número de linhas em um arquivo de texto.
    """
    with open(file_path, "r") as file:
        lines = file.readlines()
    return len(lines)
