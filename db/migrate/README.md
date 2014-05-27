# Migrations

Maintaining the collection of the migrations used to recreate
the existing database is critical. There are multiple ways of determining the order of
migrations. We use the current time in seconds to organize the migrations.

After a migration is published, i.e., after it is pushed to master, it should 
never be modified.

## Creating a new migration

A template for new migrations is generated when you run `rake 
db:new_migration`. This rake task expects a single argument: the name of the 
migration, e.g.,

    rake db:new_migration[add_gravatar_to_users]

This will create a template in the migrations directory (`db/migrate`).
By default, the file will have

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
about writing migrations, but we will summarize some of it here. Your 
most common operations will likely be creating and altering tables. If you
wanted to create a table called `users` you would write something like

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
