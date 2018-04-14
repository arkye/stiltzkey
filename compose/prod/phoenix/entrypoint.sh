#!/usr/bin/env bash

cmd="$@"

printf "\n## Mix Version\n\n"
mix -v
mix phx.new -v

printf "\n## Updating Dependencies\n\n"
mix deps.get --only prod
mix compile

printf "\n## Compiling Submodules\n\n"
cd deps/argon2_elixir
make clean
make

cd /code/assets
node_modules/brunch/bin/brunch build --production

cd /code
mix phx.digest

printf "\n## Creating Database\n\n"
mix ecto.create
mix ecto.migrate

exec $cmd
