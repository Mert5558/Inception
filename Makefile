NAME = inception
COMPOSE = docker compose -f ./srcs/docker-compose.yml

all: up

up:
	@echo "staring containers..."
	@$(COMPOSE) up --build -d 

down:
	@echo "stopping containers..."
	@$(COMPOSE) down

restart: down up

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

clean:
	@echo "removing containers..."
	@$(COMPOSE) down

prune:
	@echo "removing unused docker objects..."
	@docker system prune -a

fclean: clean prune
	@echo "removing images..."
	@docker rmi $$(docker images -q) --force || true
	@echo "removing database and web"
	@rm -rf ./src/database ./src/web

re: fclean up

.PHONY: all up down restart logs ps clean fclean re prune
