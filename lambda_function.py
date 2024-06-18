import json

def lambda_handler(event, context):
    # Obter o valor passado no POST
    body = event.get('body', '')

    # Tratar a entrada de dados
    if isinstance(body, str):
        data = body
    else:
        data = json.dumps(body)

    # Cria a resposta com o prefixo 'ECHO: '
    response = f'ECHO: {data}'

    return {
        'statusCode': 200,
        'body': response
    }
