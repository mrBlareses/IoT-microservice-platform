# IoT Microservice Platform

## Содержание
- [Архитектура](#архитектура)
- [Состав репозитория](#состав-репозитория)
- [Быстрый старт](#быстрый-старт)
- [Ручной запуск (без Makefile)](#ручной-запуск-без-makefile)
- [Порты и сервисы](# порты-и-сервисы)
- [Конфигурация (ENV)](#конфигурация-env)
- [Наблюдаемость](#наблюдаемость)
- [Ветки и стратегия](#ветки-и-стратегия)
- [Типовые ошибки и устранение](#типовые-ошибки-и-устранение)
- [Структура каталогов](#структура-каталогов)

---

## Архитектура

Платформа моделирует работу IoT-системы с использованием микросервисной архитектуры.  
Основные компоненты:
- PostgreSQL (хранение данных пользователей и ролей)
- Redis (кэш и состояния)
- Kafka + Zookeeper (шина событий)
- MinIO (объектное хранилище)
- Keycloak (аутентификация и авторизация)
- Camunda (оркестрация процессов)
- Prometheus, Grafana, Loki, Tempo (наблюдаемость и мониторинг)

---

## Состав репозитория

- `infrastructure/` — docker-compose инфраструктуры (БД, брокеры, observability).
- `api/` — Individuals API (WebFlux).
- `person-service/` — Persons Service (CRUD).
- `Makefile` — удобные команды для запуска и обслуживания окружения.
- `README.md` — документация.

---

## Быстрый старт

```bash
# Запуск всех сервисов
make up

# Просмотр логов
make logs

# Проверка статуса
make ps

# Перезапуск сервисов
make restart

# Полная очистка окружения
make clean
```

Требуется: Docker (compose), JDK 24, make.

---

## Ручной запуск (без Makefile)

```bash
# Запуск всех сервисов напрямую
docker compose -f docker-compose.yml --env-file .env up -d

# Остановка
docker compose -f docker-compose.yml --env-file .env down
```

---

## Порты и сервисы

| Сервис            | Порт (host) | Описание                                     |
|-------------------|-------------|----------------------------------------------|
| Keycloak          | 8080        | Dev-режим, импорт realm `individual`         |
| Prometheus        | 9090        | Метрики                                      |
| Grafana           | 3000        | Dashboard + Explore                          |
| Tempo             | 3200        | Хранилище трассировок (OTLP)                 |
| Loki              | 3100        | Хранилище логов                              |
| Postgres (persons)| 5434        | Контейнер `person-postgres`                  |

---

## Наблюдаемость

- Prometheus: [http://localhost:9090](http://localhost:9090)  
- Grafana: [http://localhost:3000](http://localhost:3000)  
- Loki: [http://localhost:3100](http://localhost:3100)  
- Tempo: [http://localhost:3200](http://localhost:3200)

---

## Типовые ошибки и устранение

- **Проблема с портами** — убедитесь, что порты не заняты локальными сервисами.  
- **Keycloak не стартует** — проверьте, что Postgres поднят и доступен.  
- **Grafana пустая** — настройте data source на Prometheus.  

---

## Структура каталогов

```
iot-platform/
├── diagrams/                     # C4-диаграммы архитектуры
│   ├── containers.puml
│   └── context.puml
├── infrastructure/               # Инфраструктура Docker
│   ├── monitoring/
│   │   ├── prometheus/prometheus.yml
│   │   ├── loki/loki-config.yaml
│   │   ├── tempo/tempo-config.yaml
│   │   └── grafana/{dashboards,provisioning}
├── docker-compose.yaml           # Docker Compose для сервисов
├── .env.example                  # Пример конфигурации окружения
├── .env                          # Локальные переменные (в .gitignore)
├── README.md                     # Документация проекта
└── Makefile                      # Утилитарные команды
```
