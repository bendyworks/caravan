# Migrations

It is crucial to maintain the collection of the migrations used to recreate 
the existing database. There are multiple ways of determining the order of 
migrations. We could use a naming system similar to Rails, e.g., 
`YYYYMMDD_name.rb` or more simply, an incremental numbering scheme. Moz chose 
the latter so we also did for the purpose of this case study. Migrations are 
numbered starting at 1.

After a migration is published, i.e., after it is pushed to master, it should 
never be modified.

## Creating a new migration

A template for new migrations is generated when you run `rake 
db:new_migration`. This rake task expects a single argument: the name of the 
migration, e.g.,

    rake db:new_migration[add_gravatar_to_users]

This will create a template in this directory (`db/migrate`). If prior to 
running the rake task, your last migration was `0003_add_repository_table.rb`, 
your new file will be `0004_add_gravatar_to_users.rb`. By default, the file 
will have

```ruby
Sequel.migration do
  # If your migration is simple, you can simplify this to
  # change do
  # end

  up do
  end

  down do
  end
end
```

already inside of it. The [Sequel gem][migrations] has good documentation 
about writing migrations with it, but we will summarize a bit of it here. Your 
most common operations will likely be creating and altering tables. If you 
were to create a table called `users` you might write something like

```ruby
Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :username
      String :name
      String :location
      Integer :repository_count
      Integer :private_repository_count
    end
  end

  down do
    drop_table :users
  end
end
```

or


```ruby
Sequel.migration do
  up do
    alter_table :users do
      add_column :followers, Integer
    end
  end

  down do
    alter_table :users do
      drop_column :followers
    end
  end
end
```


[migrations]: http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html
