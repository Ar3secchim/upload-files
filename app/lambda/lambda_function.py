import json
import boto3
import os
from datetime import datetime

# Inicializa o cliente DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMODB_TABLE"]
table = dynamodb.Table(table_name)

# Inicializa o cliente S3
s3_client = boto3.client("s3")

def lambda_handler(event, context):
    print("Event Received:", json.dumps(event, indent=2))

    # Processa cada mensagem no evento SQS
    for record in event["Records"]:
        # Extrai o corpo da mensagem
        message_body = json.loads(record["body"])

        # Verifica se a mensagem é de um SNS
        if "Message" in message_body:
            sns_message = json.loads(message_body["Message"])

            # Verifica se há eventos do S3
            if "Records" in sns_message:
                s3_event = sns_message["Records"][0]
                s3_bucket = s3_event["s3"]["bucket"]["name"]
                s3_object_key = s3_event["s3"]["object"]["key"]

                print(f"Processing file {s3_object_key} from bucket {s3_bucket}.")

                # Faz download do arquivo para o diretório temporário
                local_file_path = f"/tmp/{os.path.basename(s3_object_key)}"
                try:
                    s3_client.download_file(s3_bucket, s3_object_key, local_file_path)
                    print(f"File downloaded to {local_file_path}")

                    # Conta as linhas do arquivo
                    num_lines = count_lines(local_file_path)

                    # Grava no DynamoDB
                    write_to_dynamodb(s3_object_key, num_lines)
                except Exception as e:
                    print(f"Erro ao processar o arquivo {s3_object_key}: {e}")
            else:
                print("Nenhum evento do S3 encontrado na mensagem do SNS.")
        else:
            print("Mensagem não reconhecida no corpo do SQS.")

    return {"statusCode": 200, "body": "Processed successfully"}

def count_lines(file_path):
    """Conta o número de linhas no arquivo."""
    with open(file_path, "r") as file:
        lines = file.readlines()
    return len(lines)

def write_to_dynamodb(file_name, num_lines):
    """Grava informações no DynamoDB."""
    try:
        response = table.put_item(
            Item={
                "file_name": file_name,
                "num_lines": num_lines,
                "created_at": datetime.utcnow().isoformat()
            }
        )
        print(f"Item inserido com sucesso: {response}")
    except Exception as e:
        print(f"Erro ao inserir no DynamoDB: {e}")
