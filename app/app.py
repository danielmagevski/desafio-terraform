from flask import Flask, request

app = Flask(__name__)

@app.route('/', methods=['POST'])
def echo():
    # Obtém o valor passado no POST
    data = request.get_data(as_text=True)
    
    # Cria a resposta com o prefixo 'ECHO: '
    response = f'ECHO: {data}'
    
    return response, 200

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)
