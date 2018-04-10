FROM arkye/stiltzkey-phoenix:latest

COPY ./compose/test/phoenix/entrypoint.sh /entrypoint.sh
COPY ./compose/test/phoenix/test.sh /test.sh
COPY ./stiltzkey /code

WORKDIR /code

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/test.sh"]
