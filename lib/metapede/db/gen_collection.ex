defmodule Metapede.Db.GenCollection do
  defmacro __using__(collection_name: collection_name) do
    quote do
      @repo :mongo
      @collection unquote(collection_name)

      def create(attrs) do
        @repo
        |> Mongo.insert_one(@collection, attrs)
      end

      def get_by_id(id) do
        @repo
        |> Mongo.find_one(@collection, %{_id: id})
      end

      def get_all() do
        @repo
        |> Mongo.find(@collection, %{})
        |> Enum.to_list()
      end

      def upsert(filter, updates) do
        @repo
        |> Mongo.update_one(
          @collection,
          filter,
          %{"$set" => updates},
          upsert: true
        )

        find_one_by(filter)
      end

      def find_one_by(filter, opts \\ []) do
        @repo
        |> Mongo.find_one(@collection, filter, opts)
      end

      def delete(id) do
        @repo
        |> Mongo.delete_one(@collection, %{_id: id})
      end

      def load(id, _resource), do: get_by_id(id)
      def extract_and_ref(schema), do: upsert(schema, schema) |> Map.get("_id")

      defoverridable extract_and_ref: 1, load: 2
    end
  end
end
