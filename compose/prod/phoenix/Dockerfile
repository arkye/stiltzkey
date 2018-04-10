FROM arkye/stiltzkey-phoenix:latest

COPY ./compose/prod/phoenix/entrypoint.sh /entrypoint.sh
COPY ./compose/prod/phoenix/start.sh /start.sh
COPY ./stiltzkey /code

WORKDIR /code

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/start.sh"]
