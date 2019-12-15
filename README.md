# shortify

A simple URL shortener.

# Projects

- [First release](https://github.com/rodrigo93/shortify/projects/1)

# Stack

## Tools

### Lints
#### Ruby

- [brakeman](https://github.com/presidentbeef/brakeman): static analysis security vulnerability scanner for Ruby on Rails applications (via [pronto-brakeman](https://github.com/prontolabs/pronto-brakeman))
- [fasterer](https://github.com/DamirSvrtan/fasterer): performance checker and suggester (via [pronto-fasterer](https://github.com/prontolabs/pronto-fasterer))
- [flay](https://github.com/seattlerb/flay): analyzes code for structural similarities (via [pronto-flay](https://github.com/prontolabs/pronto-flay))
- [reek](https://github.com/troessner/reek): code smell detector for Ruby (via [pronto-reek](https://github.com/prontolabs/pronto-reek))
- [rubocop](https://github.com/rubocop-hq/rubocop): Ruby static code analyzer and formatter, based on the community Ruby style guide (via [pronto-rubocop](https://github.com/prontolabs/pronto-rubocop))

#### Git

- [poper](https://github.com/mmozuras/poper): makes sure that your git commit messages are well-formed (via [pronto-poper](https://github.com/prontolabs/pronto-poper))


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

> `dev/bash`

Open a bash session inside a temporary `shortify` container.

> `dev/build`

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
