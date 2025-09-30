# IoT Microservice Platform - Makefile
# Упрощенное управление Docker Compose окружением

# Переменные
COMPOSE_FILE = docker-compose.yml
ENV_FILE = .env

# Цвета для вывода
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Метки, которые не являются файлами
.PHONY: help up down logs ps clean-kafka-cluster

# По умолчанию показываем справку
.DEFAULT_GOAL := help

help: ## Показать справку по доступным командам
	@echo "$(GREEN)IoT Microservice Platform - Management Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Доступные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

up: ## Запуск всех контейнеров
	@echo "$(GREEN)Запуск IoT Platform...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d
	@echo "$(GREEN)✓ Все контейнеры запущены$(NC)"

down: ## Остановка и удаление всех контейнеров
	@echo "$(GREEN)Остановка IoT Platform...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down
	@echo "$(GREEN)✓ Контейнеры остановлены$(NC)"

logs: ## Просмотр логов контейнеров (с флагом -f для слежения)
	@echo "$(GREEN)Просмотр логов IoT Platform...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

ps: ## Показать статус контейнеров
	@echo "$(GREEN)Статус контейнеров IoT Platform...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) ps

clean-kafka-cluster: ## Очистка Kafka кластера
	@echo "$(GREEN)Очистка Kafka кластера...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) rm -f zookeeper kafka1 kafka2 kafka3
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down -v zookeeper kafka1 kafka2 kafka3
	@echo "$(GREEN)✓ Kafka кластер очищен$(NC)"