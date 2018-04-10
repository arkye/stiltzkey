FROM node as node

FROM elixir

COPY --from=node /usr/local/ /usr/local/
COPY --from=node /opt/ /opt/

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force \
    https://github.com/phoenixframework/archives/raw/master/phx_new.ez
