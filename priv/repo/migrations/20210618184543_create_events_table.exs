defmodule Metapede.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      timestamps()
    end
  end
end
