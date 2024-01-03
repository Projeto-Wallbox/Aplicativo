import asyncio
import websockets
import json

async def handle_login(websocket, path):
    try:
        # Aguarda a mensagem do cliente
        message = await websocket.recv()

        # Converte a mensagem JSON para um dicionário
        data = json.loads(message)

        # Verifica se a mensagem é uma requisição de login
        if data.get('type') == 'authenticateRequest':
            username = data.get('login')
            password = data.get('password')

            # Simula a autenticação (substitua isso pela lógica real de autenticação)
            if username == 'usuario' and password == 'senha':
                response = {'type': 'userAuthResponse','status': 'Ok', 'message': 'Login bem-sucedido'}
            else:
                response = {'type': 'userAuthResponse','status': 'error', 'message': 'Credenciais inválidas'}
        else:
            response = {'status': 'error', 'message': 'Ação desconhecida'}

        # Envia a resposta de volta para o cliente
        await websocket.send(json.dumps(response))
    except websockets.exceptions.ConnectionClosed:
        print("Conexão fechada pelo cliente")

async def main():
    # Inicia o servidor WebSocket
    server = await websockets.serve(handle_login, "localhost", 80)

    print("Servidor WebSocket iniciado. Aguardando conexões...")

    # Mantém o servidor em execução indefinidamente
    await server.wait_closed()

# Inicia o loop de eventos assíncronos
asyncio.run(main())