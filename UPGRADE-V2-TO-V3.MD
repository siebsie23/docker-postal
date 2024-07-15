# Upgrade guide for v2 to v3

To upgrade docker-postal from v2 to v3 there are a few small changes you have to make to your configuration.
This is split into 2 taks.

- Remove the RabbitMQ service from your docker-compose file.
- Update environment variables to the new ones in place because of the updated postal configuration file.


## Removing old containers
Open your `docker-compose.yml` and remove the `postal-rabbitmq` service block from the yml file.
If you are using the docker-compose example provided in this repository, all of the following should be removed:
```yml
  postal-rabbitmq:
    container_name: postal-rabbitmq
    image: rabbitmq:3
    environment:
      - RABBITMQ_DEFAULT_USER=postal
      - RABBITMQ_DEFAULT_PASS=password
      - RABBITMQ_DEFAULT_VHOST=/postal
      - CONTAINER_NAME=postal-rabbitmq
    networks:
      - services
    restart: always
```
You can take a look at the updated [docker-compose.yml](examples/docker-compose.yml) in this repository as an example.

## Updating environment variables
Some existing variables have been updated, you should update them in your docker-compose.yml to prevent issues.

If a variable has been removed, the table below will show it as a `-`

| Old variable                  | New variable                          |
| ----------------------------- | ------------------------------------- |
| `DNS_HOSTNAME`                | `DNS_HELO_HOSTNAME`                   |
| `DNS_SPF`                     | `DNS_SPF_INCLUDE`                     |
| `DNS_RETURN_PATH`             | `DNS_RETURN_PATH_DOMAIN`              |
| `WORKERS_AMOUNT`              | -                                     |
| -                             | `WEB_MAX_THREADS`                     |
| `RABBITMQ_HOST`               | -                                     |
| `RABBITMQ_VHOST`              | -                                     |
| `RABBITMQ_USER`               | -                                     |
| `RABBITMQ_PASS`               | -                                     |
| `RABBITMQ_PORT`               | -                                     |
| `SMTP_SERVER_HELO_HOSTNAME`   | `SMTP_SERVER_HOSTNAME`                |
| `SMTP_SERVER_SSL_VERSION`     | `SMTP_SERVER_TLS_SSL_VERSION`         |
| `WEB_BIND_IP`                 | `WEB_BIND_ADDRESS`                    |
| `WEB_BIND_PORT`               | `WEB_PORT`                            |
| -                             | `WORKER_HEALTH_SERVER_BIND_ADDRESS`   |
| -                             | `WORKER_HEALTH_SERVER_PORT`           |
| `WEB_HOST`                    | `WEB_HOSTNAME`                        |