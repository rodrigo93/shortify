# shortify

A simple URL shortener.

## Summary
- [Projects](#projects)
- [Stack](#stack)
  * [Tools](#tools)
    + [Lints](#lints)
      - [Ruby](#ruby)
      - [Git](#git)
- [Setup](#setup)
  * [Downloading and installation](#downloading-and-installation)
- [Running](#running)
- [Available commands](#available-commands)
- [Endpoints](#endpoints)
  * [POST shorten](#post-shorten)
    + [Returns](#returns)
    + [Errors](#errors)
  * [GET shorten](#get-shorten)
    + [Returns](#returns-1)
    + [Errors](#errors-1)
  * [GET stats](#get-stats)
    + [Returns](#returns-2)
    + [Errors](#errors-2)

# Projects

- [First release](https://github.com/rodrigo93/shortify/projects/1)

# Stack

- Docker
- SQLite
- Rails 6.0.0
- Ruby 2.6.5
- Rspec

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

# Running

All you need to do to run this project is running the following command in the root directory of this project:

```shell
$ docker-compose up
```

Wait for the build and shortify! :D

# Available commands

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

# Endpoints

## POST shorten

```
POST /shorten
Content-Type: "application/json"

{
  "url": "http://example.com",
  "shortcode": "example"
}
```

Attribute | Description
--------- | -----------
**url**   | url to shorten
shortcode | preferential shortcode


### Returns

```
201 Created
Content-Type: "application/json"

{
  "shortcode": :shortcode
}
```

A random shortcode is generated if none is requested, the generated short code has exactly 6 alpahnumeric characters and passes the following regexp: ```^[0-9a-zA-Z_]{6}$```.

### Errors

Error | Description
----- | ------------
400   | ```url``` is not present
409   | The the desired shortcode is already in use. **Shortcodes are case-sensitive**.
422   | The shortcode fails to meet the following regexp: ```^[0-9a-zA-Z_]{4,}$```.


## GET shorten

```
GET /:shortcode
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

### Returns

**302** response with the location header pointing to the shortened URL

```
HTTP/1.1 302 Found
Location: http://www.example.com
```

### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system


## GET stats

```
GET /:shortcode/stats
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

### Returns

```
200 OK
Content-Type: "application/json"

{
  "startDate": "2012-04-23T18:25:43.511Z",
  "lastSeenDate": "2012-04-23T18:25:43.511Z",
  "redirectCount": 1
}
```

Attribute         | Description
--------------    | -----------
**startDate**     | date when the url was encoded, conformant to [ISO8601](http://en.wikipedia.org/wiki/ISO_8601)
**redirectCount** | number of times the endpoint ```GET /shortcode``` was called
lastSeenDate      | date of the last time the a redirect was issued, not present if ```redirectCount == 0```


### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system
