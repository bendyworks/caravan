Sequel.migration do
  up do
    # Table shamelessly stolen from GitHub's API
    create_table(:users) do
      primary_key :id
      String :company
      String :html_url
      String :location
      String :login
      String :name
      String :url
    end
  end

  down do
    drop_table(:users)
  end
end
