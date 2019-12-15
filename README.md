# shortify

A simple URL shortener.

# Stack

_TODO_

# Setup

For this project, we use Docker and docker-compose. So if you want to run this project,
be sure to have both installed before continuing.

You can follow [this tutorial](https://docs.docker.com/compose/install/) explaining how to install them.

## Downloading and installation

To download and install this project, just run the following commands:

```shell
$ git clone git@github.com:rodrigo93/shortify.git
$ docker-compose up
```

This might take some minutes, depending on you internet speed to download the necessary images.

## Running

_TODO_

### Available commands

- `dev/build`

Build and run everything that is declared in `Dockerfile`.

> `dev/bundle-install`

Runs `bundle install` inside a temporary `shortify` container.

> `dev/bundle-update`

Runs `bundle update` inside a temporary `shortify` container. 

> `dev/console`

Open a `rails console` inside a container. By default it will open inside the `shortify` container.

> `dev/lint`

Run all configured lints in the project.

> `dev/logs`

Check log outputs from `shortify` container.

> `dev/restart`

Restarts all containers from this project.

> `dev/rspec FILE_PATH`

Run all RSpec tests or just the given specs passed in the `FILE_PATH` argument.

> `dev/start`

Start all containers from this project.

> `dev/stop`

Stop all containers from this project.
