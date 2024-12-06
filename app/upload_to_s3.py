import boto3
import os
import uuid
import random
from dotenv import load_dotenv

load_dotenv()

# Configuração AWS via variáveis de ambiente
AWS_REGION = os.getenv("AWS_REGION")
BUCKET_NAME = os.getenv("BUCKET_NAME")

# Geração do arquivo
def generate_file():
    filename = f"{uuid.uuid4()}.txt"
    num_lines = random.randint(10, 100)

    with open(filename, "w") as file:
        for _ in range(num_lines):
            file.write(f"Line {_ + 1}\n")
    return filename, num_lines

# Upload para o S3
def upload_to_s3(filename):
    s3 = boto3.client("s3", region_name=AWS_REGION)
    s3.upload_file(filename, BUCKET_NAME, filename)
    print(f"File {filename} uploaded to S3 bucket {BUCKET_NAME}.")
    os.remove(filename)

if __name__ == "__main__":
    file_name, lines = generate_file()
    print(f"Generated file {file_name} with {lines} lines.")
    upload_to_s3(file_name)
