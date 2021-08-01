defmodule Metapede.Utils do
  alias Metapede.Repo

  def add_association(new_assoc, parent_object, atom_name, assoc_func) do
    parent_object
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(atom_name, assoc_func.(new_assoc))
    |> Repo.update!()
  end
end
