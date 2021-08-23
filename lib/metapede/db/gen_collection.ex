defmodule Metapede.Db.GenCollection do
  defmacro __using__(collection_name: collection_name, prefix: prefix) do
    quote do
      @repo :mongo
      @collection unquote(collection_name)
      @prefix unquote(prefix)

      def create(attrs) do
        with_id = Map.put(attrs, :_id, gen_unique_id())
        Mongo.insert_one(@repo, @collection, with_id)
        with_id._id
      end

      def get_by_id(id), do: Mongo.find_one(@repo, @collection, %{_id: id})
      def get_all(), do: Mongo.find(@repo, @collection, %{}) |> Enum.to_list()
      def find_one_by(filter, opts \\ []), do: Mongo.find_one(@repo, @collection, filter, opts)
      def load(id, _resource \\ nil), do: get_by_id(id)
      def unload(schema), do: upsert(schema, schema) |> Map.get("_id")

      def update(attrs) do
        Mongo.update_one(@repo, @collection, %{_id: attrs._id}, attrs)
        attrs._id
      end

      def delete(id), do: Mongo.delete_one(@repo, @collection, %{_id: id})

      def submit(attrs) do
        update = unload(attrs)
        upsert(update)
      end

      def upsert(%{_id: _id} = attrs), do: update(attrs)
      def upsert(attrs), do: create(attrs)

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

      defp gen_unique_id() do
        id = gen_id()
        if(is_unique_id(id), do: id, else: gen_unique_id())
      end

      defp gen_id(), do: @prefix <> "_" <> UUID.uuid1(:hex)
      def is_unique_id(id), do: Mongo.count!(@repo, @collection, %{_id: id}) == 0

      defoverridable unload: 1, load: 1, load: 2
    end
  end
end
