# IoT Microservice Platform

## Содержание
- [Архитектура](#архитектура)
- [Состав репозитория](#состав-репозитория)
- [Быстрый старт](#быстрый-старт)
- [Ручной запуск (без Makefile)](#ручной-запуск-без-makefile)
- [Порты и сервисы](#порты-и-сервисы)
- [Конфигурация (ENV)](#конфигурация-env)
- [Наблюдаемость](#наблюдаемость)
- [Типовые ошибки и устранение](#типовые-ошибки-и-устранение)
- [Структура каталогов](#структура-каталогов)

---

## Архитектура

Платформа моделирует работу IoT-системы с использованием микросервисной архитектуры.  
Основные компоненты:
- PostgreSQL (хранение данных пользователей и ролей)
- Redis (кэш и состояния)
- Cassandra (База данных NoSQL)
- Kafka + Zookeeper (шина событий)
- MinIO (объектное хранилище)
- Keycloak (аутентификация и авторизация)
- Camunda (оркестрация процессов)
- Prometheus, Grafana, Loki, Tempo (наблюдаемость и мониторинг)
- Schema registry (управление схемами для Kafka)

---

## Состав репозитория

- `infrastructure/` — docker-compose инфраструктуры (БД, брокеры, observability).
- `Makefile` — удобные команды для запуска и обслуживания окружения.
- `README.md` — документация.

---

## Быстрый старт

```bash
# Показать справку по доступным командам
make help

# Запуск всех контейнеров
make up

# Остановка и удаление всех контейнеров
make down

# Просмотр логов контейнеров (с флагом -f для слежения)
make logs

# Проверка статуса
make ps

# Очистка Kafka кластера
make clean-kafka-cluster

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
| Keycloak          | 8080        | Аутентификация/авторизация                   |
| Prometheus        | 9090        | Метрики                                      |
| Grafana           | 3000        | Dashboard + Explore                          |
| Tempo             | 3200        | Хранилище трассировок (OTLP)                 |
| Loki              | 3100        | Хранилище логов                              |
| Postgres          | 5432        | Основная база данных                         |
| Postgres Exporter | 9187        | Экспортер метрик PostgreSQL для Prometheus   |   
| MinIO API         | 9000        | API для объектного хранилища                 |   
| MinIO Console     | 9001        | Веб-интерфейс для управления MinIO           |   
| Cassandra         | 9042        | База данных NoSQL                            |   
| Redis             | 6379        | Кэш и хранилище ключ-значение                |   
| Schema registry   | 8081        | Управление схемами для Kafka                 |   
| Zookeeper         | 2181        | Координация для Kafka                        |   
| Kafka1            | 9092        | Брокер Kafka 1                               |   
| Kafka2            | 9093        | Брокер Kafka 2                               |   
| Kafka3            | 9094        | Брокер Kafka 3                               |   
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
- **Не стартует Kafka кдастер** - очистите Kafka кластер  

---

## Структура каталогов

```
iot-platform/
├── diagrams/                     # C4-диаграммы архитектуры
│   ├── containers.puml
│   └── context.puml
├── infrastructure/               # Инфраструктура Docker
│   ├── monitoring/
│   │   └──grafana
│   │       └──grafana.db         # База данных Grafana (DataSource, Dashboards, Panels) 
│   ├── prometheus/prometheus.yml
│   ├── loki/loki-config.yaml
│   ├── tempo/tempo-config.yaml
│   └── grafana/{dashboards,provisioning}
├── docker-compose.yaml           # Docker Compose для сервисов
├── .env                          # Локальные переменные (в .gitignore)
├── README.md                     # Документация проекта
└── Makefile                      # Утилитарные команды
```
