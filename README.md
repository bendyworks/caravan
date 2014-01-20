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

In our client's case, this part of their infrastructure provides access to a 
large number of resources. As such, keeping the resources (or endpoints) 
organized helps and splitting them up into several smaller apps helps with 
that organization. The pattern used to keep items organized is by using the 
structure of the routes. For example, if you have a route that to the end user 
is structured `/users/:user_id/some_resource`, you might make an app 
specifically to hold all of the resources for `/users`.


## `lib/endpoint_models`

Lorem ipsum

## `lib/models`

Lorem ipsum
