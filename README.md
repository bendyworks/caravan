# Sinatra Case Study

This project is just a template used to document some of the best practices 
that we have learned while working on a very complex API project with 
[Moz](moz.com).  This project has far more moving parts, but a large part of 
what resonated specifically with us was how they designed their sinatra 
application for maintainability and versatility.

    .
    |-- Gemfile
    |-- Gemfile.lock
    |-- README.md
    |-- Rakefile
    |-- config
    |   `-- database.yml
    |-- lib
    |   |-- apps
    |   |   `-- users.rb
    |   |-- endpoint_models
    |   |   `-- users
    |   |       `-- user.rb
    |   |-- models
    |   |   `-- user.rb
    |   `-- tasks
    |       `-- db.rb
    `-- spec
        |-- acceptance
        |   `-- README.md
        |-- integration
        |   `-- endpoint_models
        |       `-- README.md
        `-- unit
            |-- endpoint_models
            |   `-- README.md
            `-- models
                `-- README.md


The importance of the directory structure is that it lends itself to keeping 
one's concerns separated. The importance of each directory is explained in 
short below, and in greater detail in the READMEs placed in each directory.

## `lib/apps`

Lorem ipsum

## `lib/endpoint_models`

Lorem ipsum

## `lib/models`

Lorem ipsum
