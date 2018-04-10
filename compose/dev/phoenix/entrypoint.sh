#!/usr/bin/env bash

cmd="$@"

printf "\n## Mix Version\n\n"
mix -v
mix phx.new -v

printf "\n## Updating Dependencies\n\n"
mix deps.get
mix deps.compile
cd assets
yarn install
node node_modules/brunch/bin/brunch build
cd /code

printf "\n## Creating Database\n\n"
mix ecto.create
mix ecto.migrate

exec $cmd
