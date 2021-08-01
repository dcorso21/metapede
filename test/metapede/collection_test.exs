defmodule Metapede.TopicSchema.TopicContextTest do
  use Metapede.DataCase

  alias Metapede.TopicSchema.TopicContext

  describe "topics" do
    alias Metapede.TopicSchema.Topic

    @valid_attrs %{description: "some description", info: "some info", name: "some name", post_id: "some post_id"}
    @update_attrs %{description: "some updated description", info: "some updated info", name: "some updated name", post_id: "some updated post_id"}
    @invalid_attrs %{description: nil, info: nil, name: nil, post_id: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collection.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Collection.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Collection.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Collection.create_topic(@valid_attrs)
      assert topic.description == "some description"
      assert topic.info == "some info"
      assert topic.name == "some name"
      assert topic.post_id == "some post_id"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collection.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Collection.update_topic(topic, @update_attrs)
      assert topic.description == "some updated description"
      assert topic.info == "some updated info"
      assert topic.name == "some updated name"
      assert topic.post_id == "some updated post_id"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Collection.update_topic(topic, @invalid_attrs)
      assert topic == Collection.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Collection.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Collection.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Collection.change_topic(topic)
    end
  end
end
