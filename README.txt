# IoT Microservice Platform

Учебный проект для демонстрации распределённой микросервисной архитектуры в контексте **Интернета вещей (IoT)**.
Платформа включает инфраструктурные сервисы (Kafka, PostgreSQL, Redis и др.), средства аутентификации и оркестрации (Keycloak, Camunda), а также инструменты мониторинга и наблюдаемости (Prometheus, Grafana, Loki, Tempo).

---

## Архитектура

Платформа моделирует работу IoT-системы:

- **PostgreSQL** – хранение пользователей, ролей и настроек.
   - Основной порт: 5432
   - Доступ: postgres:5432 (внутри docker-сети), localhost:5432 (с хоста).
   - Метрики: через Postgres Exporter → http://postgres-exporter:9187/metrics.
- **Cassandra** – долговременное хранение телеметрии и временных рядов.
   - Основной порт: 9042 (CQL).
   - Доступ: cassandra:9042 или localhost:9042.
   - Метрики: через Cassandra Exporter → http://cassandra-exporter:8080/metrics.
- **Redis** – кэширование и хранение текущих состояний устройств.
   - Основной порт: 6379.
   - Доступ: redis:6379 или localhost:6379.
   - Метрики: через Redis Exporter → http://redis-exporter:9121/metrics.
- **Kafka + Zookeeper** – шина событий и команд для обмена сообщениями между сервисами.
   - Zookeeper: zookeeper:2181.
   - Kafka Broker: kafka:9092.
   - Метрики Kafka: через Kafka Exporter → http://kafka-exporter:9308/metrics.
- **MinIO** – объектное хранилище (файлы, бинарные данные, вложения).
   - Web-интерфейс и API: http://minio:9000 или http://localhost:9000.
   - Консоль управления (если включена): http://minio:9001.
- **Keycloak** – аутентификация и авторизация (SSO, управление пользователями).
   - Админ-консоль: http://keycloak:8080 или http://localhost:8080.
   - Метрики (при включённом micrometer/metrics): http://keycloak:8080/metrics.
- **Camunda** – BPMN-оркестрация бизнес-процессов.
   - Web-интерфейс:
   - Camunda 7 → http://camunda:8080
   - Camunda 8 (Zeebe + Operate) →
   - Zeebe gRPC → zeebe:26500
   - Operate UI → http://operate:8080
   - Метрики: Prometheus endpoint у Zeebe: http://zeebe:9600/metrics.
- **Prometheus** – сбор метрик сервисов.
   - Веб-интерфейс: http://prometheus:9090 или http://localhost:9090.
   - Метрики самого Prometheus: http://prometheus:9090/metrics.
- **Grafana** – визуализация метрик, логов и трейсов.
   - Веб-интерфейс: http://grafana:3000 или http://localhost:3000.
- **Loki** – централизованный сбор логов.
   - API: http://loki:3100 или http://localhost:3100.
   - Метрики Loki: http://loki:3100/metrics.
- **Tempo** – распределённый трейсинг.
   - API: http://tempo:3200 или http://localhost:3200.
   - Метрики Tempo: http://tempo:3200/metrics.

- `context.puml` – системный контекст (C4 уровень 1)
- `containers.puml` – контейнерная диаграмма (C4 уровень 2)

---

## Структура репозитория

iot-platform/
├── diagrams/                     # C4-диаграммы архитектуры
│   ├── containers.puml
│   └── context.puml
├── infrastructure/               # Инфраструктура Docker
│
│   ├── monitoring/               # Конфиги мониторинга
│   │   ├── prometheus/
│   │   │   └── prometheus.yml    # Основной конфиг Prometheus (jobs, targets, scrape config)
│   │   ├── loki
│   │   │   └── loci-config.yaml  # Конфиг Loki для централизованного сбора логов
│   │   ├── tempo/
│   │   │   └── tempo-config.yaml # Конфиг Tempo для распределённого трейса
│   │   └── grafana/
│   │       ├── dashboards/       # JSON/конфиги дашбордов Grafana
│   │       └── provisioning/     # Автоматическая настройка источников данных и дашбордов
│   └── monitoring/               # мониторинг grafana
│
├── docker-compose.yaml           # мониторинг grafana
│
├── .env.example                  # Шаблон переменных окружения
├── .env                          # Локальные переменные (в .gitignore)
├── README.md                     # Описание проекта
└── Makefile                      # Утилитарные команды

