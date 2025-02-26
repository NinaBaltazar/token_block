# Variables
DOCKER_COMPOSE = docker-compose
SERVER_SERVICE = server
REDIS_SERVICE = redis
NGINX_SERVICE = nginx
TEST_TOKEN = 123

all: build up

## Build and Start Services ##
build:
	@echo "🚀 Construindo imagens Docker..."
	$(DOCKER_COMPOSE) build

up: build
	@echo "📦 Iniciando Docker containers..."
	$(DOCKER_COMPOSE) up -d

down:
	@echo "🛑 Parando Docker containers..."
	$(DOCKER_COMPOSE) down

restart: down up

## Logs ##
logs-server:
	@echo "📜 Vendo logs do servidor server..."
	$(DOCKER_COMPOSE) logs -f $(SERVER_SERVICE)

logs-redis:
	@echo "📜 Vendo logs do Redis..."
	$(DOCKER_COMPOSE) logs -f $(REDIS_SERVICE)

logs-nginx:
	@echo "📜 Vendo logs do Nginx..."
	$(DOCKER_COMPOSE) logs -f openresty

## Redis Token Management ##
test-redis:
	@echo "🔍 Verificando se o token $(TEST_TOKEN) está bloqueado no Redis..."
	$(DOCKER_COMPOSE) exec $(REDIS_SERVICE) redis-cli GET blocked:$(TEST_TOKEN)

set-token:
	@echo "✅ Configurando o token $(TEST_TOKEN) como válido no Redis..."
	$(DOCKER_COMPOSE) exec $(REDIS_SERVICE) redis-cli SET blocked:$(TEST_TOKEN) "0"

block-token:
	@echo "⛔ Bloqueando token $(TEST_TOKEN) no Redis..."
	$(DOCKER_COMPOSE) exec $(REDIS_SERVICE) redis-cli SET blocked:$(TEST_TOKEN) "1"

## Test Requests ##
test-server:
	@echo "🌐 Testando requisição via Nginx..."
	curl -i -H "X-Token: $(TEST_TOKEN)" http://localhost/j/

test-server-direct:
	@echo "🔗 Testando requesição diretamnete no server..."
	curl -i -H "X-Token: $(TEST_TOKEN)" http://localhost:8082/

## Cleanup ##
clean:
	@echo "🧹 Limpando Docker resources..."
	$(DOCKER_COMPOSE) down -v --remove-orphans

.PHONY: all build up down restart logs-server logs-redis logs-nginx test-redis set-token block-token test-server test-server-direct clean
