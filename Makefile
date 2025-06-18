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
	@docker volume prune

fclean: clean prune
	@echo "removing images..."
	@docker volume rm srcs_mariadb srcs_wordpress || true
	@docker rmi $$(docker images -q) --force || true

re: fclean up

.PHONY: all up down restart logs ps clean fclean re prune

# docker stop $(docker ps-qa); docker rm $(docker ps-qa);docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null