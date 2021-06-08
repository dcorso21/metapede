defmodule Metapede.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
      add :description, :string
      add :page_id, :string
      add :thumbnail, :string
      timestamps()
    end
  end
end
