FROM arkye/stiltzkey-phoenix:latest

RUN apt-get update \
    && apt-get install -y inotify-tools \
    && apt-get clean

COPY ./compose/dev/phoenix/entrypoint.sh /entrypoint.sh
COPY ./compose/dev/phoenix/start.sh /start.sh
COPY ./stiltzkey /code

WORKDIR /code

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/start.sh"]
