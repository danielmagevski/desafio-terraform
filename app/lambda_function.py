import json

def lambda_handler(event, context):
    body = event.get('body', '')
    if isinstance(body, str):
        data = body
    else:
        data = json.dumps(body)
    response = f"ECHO:{data}\n"

    return {
        'statusCode': 200,
        'body': response
    }
