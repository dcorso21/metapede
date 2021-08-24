defmodule Metapede.Db.GenCollection do
  defmacro __using__(
             collection_name: collection_name,
             prefix: prefix,
             has_topic: has_topic
           ) do
    quote do
      @repo :mongo
      @collection unquote(collection_name)
      @prefix unquote(prefix)
      # @has_topic unquote(has_topic)

      def create(attrs) do
        with_id = Map.put(attrs, "_id", gen_unique_id())
        Mongo.insert_one(@repo, @collection, with_id)
        get_by_id(with_id["_id"])
      end

      def get_by_id(id), do: Mongo.find_one(@repo, @collection, %{"_id" => id})
      def get_all(), do: Mongo.find(@repo, @collection, %{}) |> Enum.to_list()
      def find_one_by(filter, opts \\ []), do: Mongo.find_one(@repo, @collection, filter, opts)

      def update(attrs) do
        Mongo.update_one(@repo, @collection, %{_id: attrs["_id"]}, attrs)
        get_by_id(attrs["_id"])
      end

      def delete(id), do: Mongo.delete_one(@repo, @collection, %{"_id" => id})

      def submit(attrs) do
        update = unload(attrs)
        upsert(update)
      end

      def upsert(%{"_id" => _id} = attrs), do: update(attrs)
      def upsert(attrs), do: create(attrs)

      unquote(if(has_topic, do: with_topic_loaders(), else: no_topic_loaders()))
      def load_all(schemas), do: Enum.map(schemas, &load/1)
      def unload_all(schemas), do: Enum.map(schemas, &unload/1)

      unquote(id_gen_funcs())

      defoverridable unload: 1, load: 1, load: 2
    end
  end

  def id_gen_funcs() do
    quote do
      defp gen_unique_id() do
        id = gen_id()
        if(is_unique_id(id), do: id, else: gen_unique_id())
      end

      defp gen_id(), do: @prefix <> "_" <> UUID.uuid1(:hex)
      def is_unique_id(id), do: Mongo.count!(@repo, @collection, %{"_id" => id}) == 0
    end
  end

  def with_topic_loaders() do
    quote do
      def load(id, _resource \\ nil), do: get_by_id(id)
      def unload(schema), do: upsert(schema) |> Map.get("_id")
    end
  end

  def no_topic_loaders() do
    quote do
      def load(id, _resource \\ nil), do: get_by_id(id)
      def unload(schema), do: upsert(schema) |> Map.get("_id")
    end
  end
end
