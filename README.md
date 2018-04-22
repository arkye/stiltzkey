# Stiltzkey

A platform designed to allow you whisper your secrets safely.

[![GitHub license](https://img.shields.io/github/license/arkye/stiltzkey.svg)](https://github.com/arkye/stiltzkey/blob/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/arkye/stiltzkey.svg)](https://github.com/arkye/stiltzkey/releases)

| Environment | CI Status |  Website |
|:-:|:-:|:-:|
| Development | [![pipeline status](https://gitlab.com/arkye/stiltzkey/badges/master/pipeline.svg)](https://gitlab.com/arkye/stiltzkey/commits/master) | [stiltzkey.dev.lappis.rocks](http://stiltzkey.dev.lappis.rocks) |
| Production | [![pipeline status](https://gitlab.com/arkye/stiltzkey/badges/develop/pipeline.svg)](https://gitlab.com/arkye/stiltzkey/commits/develop) | [stiltzkey.lappis.rocks](https://stiltzkey.lappis.rocks) |

## What is it?

Stiltzkey is a platform which allow users to manage and share secrets:

* A pair of **key** and **value** is called a **Verse**. Example:
    * **key**: `password`
    * **value**: `MyAwesomePassword`
* A collection of **Verses** is called a **Stanza** and is defined by a **context** and **description**. This can be used to group secrets by context. Example:
    * **context**: `Github`
    * **description**: `My Github secrets`
* A collection of **Stanzas** is called a **Poem** and is defined by a **title** and **description**. This can be used to group contexts. Example:
    * **title**: `Accounts`
    * **description**: `My Accounts`
* A **Movement** is a group of users with shared secrets. The **Leader** of the Movement can add users and verses. A **Poet** of the Movement can add verses. A **Enthusiast** of the Movement can only see verses.

## How it was made?

Stiltzkey was made using [Phoenix](http://phoenixframework.org/) - the standard [Elixir](https://elixir-lang.org/)'s framework, and the user interface was made using [Materialize](http://materializecss.com/).

For Continuous Integration & Continuous Deployment, Stiltzkey uses [GitLab CI/CD](https://about.gitlab.com/features/gitlab-ci-cd/) and [Docker](https://www.docker.com/).

The project is maintained by [LAPPIS](https://fga.unb.br/lappis), a Brazilian software lab.

## Deployment using Docker

The [Stiltzkey Docker Image](https://hub.docker.com/r/arkye/stiltzkey/) generates automatically by [GitLab CI/CD](/.gitlab-ci.yml) using the [docker-compose](https://docs.docker.com/compose/) files [build.production](/docker-compose.build.production.yml) (tag `latest`) and [build.staging](/docker-compose.build.staging.yml) (tag `staging`).

An example of docker-compose deployment configuration is defined at [compose/docker-compose.deploy.example.yml](/compose/docker-compose.deploy.example.yml).

If you don't have Docker, please install it following the instructions from this [link](https://docs.docker.com/install/).

If you don't have Docker Compose, please install it following the instruction from this [link](https://docs.docker.com/compose/install/).

### Steps

1. Make a local copy of the deployment configuration file
    * For this example, the path of the file is: `~/stiltzkey/docker-compose.deploy.yml`
1. Change the environment variables values
1. Change the ports value, if necessary
1. Change the volumes paths
1. Start the services using docker-compose:

    ```bash
    sudo docker-compose -f ~/stiltzkey/docker-compose.deploy.yml -p stiltzkey up -d
    ```

## Development

The development configuration can be set using Docker. Since the project was entirely configured using Docker and its images, the approach defined below is recommended.

The Phoenix cheat sheet is defined at [stiltzkey/README.md](/stiltzkey).

### Quick Start

#### Prerequisites

* [Docker](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

#### Steps

1. Clone the project:

    ```bash
    git clone git@github.com:arkye/stiltzkey.git
    cd stiltzkey
    ```
1. Start the services using docker-compose:

    ```bash
    sudo docker-compose -p stzk up -d
    ```
1. To test using docker-compose, run an instance using the test compose:

    ```bash
    sudo docker-compose -f docker-compose.test.yml -p stzktest run --rm phoenix
    sudo docker-compose -f docker-compose.test.yml -p stzktest down
    ```
