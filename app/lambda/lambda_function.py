import json
import boto3
import os

def lambda_handler(event, context):
    # Log do evento recebido
    print("Received event:", json.dumps(event, indent=2))

    s3_client = boto3.client("s3")
    bucket_name = os.environ["BUCKET_NAME"]

    # Processar o evento
    for record in event["Records"]:
        s3_object = record["s3"]["object"]["key"]
        print(f"File uploaded: {s3_object} in bucket {bucket_name}")

      # TODO: fazer logica de processamento de linhas do arquivo

    return {"statusCode": 200, "body": "Success"}
