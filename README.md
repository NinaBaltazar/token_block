# Bloqueio de Tokens com NGINX e Redis

Este projeto demonstra como configurar o NGINX para bloquear ou permitir acesso com base em tokens armazenados no Redis.

## Estrutura do Projeto
````
/token-blocker-nginx-redis/
├── nginx/
│   ├── nginx.conf
│   └── lua/
│       └── block_token.lua
├── server/
│   ├── node_modules/
│   ├── package-lock.json
│   ├── package.json
│   ├── server.js
│   └── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
````

## Configuração do NGINX

A configuração do NGINX está definida no arquivo `nginx.conf`. O NGINX utiliza um script Lua para verificar se o token fornecido na URL está presente no Redis. Se o token estiver presente, a requisição é bloqueada com um status `403 Forbidden`. Caso contrário, a requisição é permitida com um status `200 OK`.

### Executando o projeto

Para executar o projeto localmente, basta executar o comando abaixo:

````
make up
````

Isso vai iniciar os containers Docker com a porta 80 exposta. Seguindo a configuração acima, qualquer requisição para a rota /j/<token>/ será verificada no Redis. Se o token estiver presente, a requisição será bloqueada e retornará um status 403. Caso contrário, a requisição será permitida e retornará um status 200.

### Adicionando um token no Redis

Para adicionar um token no Redis, execute o comando abaixo:
````
make set-token
````

### Adicionando um token no Redis

Para bloquear um token no Redis, execute o comando abaixo:
````
make block-token
````
### Testando o bloqueio de tokens
Teste a rota com um token bloqueado:
````
make test-server
````
Você deve receber uma resposta 403 Forbidden.

Teste a rota com um token válido:
````
make test-server
````
Você deve receber uma resposta 200 OK.

### Parando o projeto
Para parar os serviços Docker, execute o comando abaixo:
````
make down
````
