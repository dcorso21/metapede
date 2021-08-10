defmodule Metapede.Db.GenCollection do
  defmacro __using__(collection_name: collection_name) do
    quote do
      @repo :mongo
      @collection unquote(collection_name)

      def create(attrs), do: Mongo.insert_one(@repo, @collection, attrs)
      def get_by_id(id), do: Mongo.find_one(@repo, @collection, %{_id: id})
      def get_all(), do: Mongo.find(@repo, @collection, %{}) |> Enum.to_list()
      def find_one_by(filter, opts \\ []), do: Mongo.find_one(@repo, @collection, filter, opts)
      def load(id, _resource \\ nil), do: get_by_id(id)
      def unload(schema), do: upsert(schema, schema) |> Map.get("_id")
      def delete(id), do: Mongo.delete_one(@repo, @collection, %{_id: id})


      def upsert(filter, updates) do
        Mongo.update_one(
          @repo,
          @collection,
          filter,
          %{"$set" => updates},
          upsert: true
        )

        find_one_by(filter)
      end


      defoverridable unload: 1, load: 1, load: 2
    end
  end
end
