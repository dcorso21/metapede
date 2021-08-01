defmodule MetapedeWeb.TopicLiveTest do
  use MetapedeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Metapede.TopicSchema.TopicContext

  @create_attrs %{description: "some description", info: "some info", name: "some name", post_id: "some post_id"}
  @update_attrs %{description: "some updated description", info: "some updated info", name: "some updated name", post_id: "some updated post_id"}
  @invalid_attrs %{description: nil, info: nil, name: nil, post_id: nil}

  defp fixture(:topic) do
    {:ok, topic} = Collection.create_topic(@create_attrs)
    topic
  end

  defp create_topic(_) do
    topic = fixture(:topic)
    %{topic: topic}
  end

  describe "Index" do
    setup [:create_topic]

    test "lists all topics", %{conn: conn, topic: topic} do
      {:ok, _index_live, html} = live(conn, Routes.topic_index_path(conn, :index))

      assert html =~ "Listing Topics"
      assert html =~ topic.description
    end

    test "saves new topic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.topic_index_path(conn, :index))

      assert index_live |> element("a", "New Topic") |> render_click() =~
               "New Topic"

      assert_patch(index_live, Routes.topic_index_path(conn, :new))

      assert index_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#topic-form", topic: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.topic_index_path(conn, :index))

      assert html =~ "Topic created successfully"
      assert html =~ "some description"
    end

    test "updates topic in listing", %{conn: conn, topic: topic} do
      {:ok, index_live, _html} = live(conn, Routes.topic_index_path(conn, :index))

      assert index_live |> element("#topic-#{topic.id} a", "Edit") |> render_click() =~
               "Edit Topic"

      assert_patch(index_live, Routes.topic_index_path(conn, :edit, topic))

      assert index_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#topic-form", topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.topic_index_path(conn, :index))

      assert html =~ "Topic updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes topic in listing", %{conn: conn, topic: topic} do
      {:ok, index_live, _html} = live(conn, Routes.topic_index_path(conn, :index))

      assert index_live |> element("#topic-#{topic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#topic-#{topic.id}")
    end
  end

  describe "Show" do
    setup [:create_topic]

    test "displays topic", %{conn: conn, topic: topic} do
      {:ok, _show_live, html} = live(conn, Routes.topic_show_path(conn, :show, topic))

      assert html =~ "Show Topic"
      assert html =~ topic.description
    end

    test "updates topic within modal", %{conn: conn, topic: topic} do
      {:ok, show_live, _html} = live(conn, Routes.topic_show_path(conn, :show, topic))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Topic"

      assert_patch(show_live, Routes.topic_show_path(conn, :edit, topic))

      assert show_live
             |> form("#topic-form", topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#topic-form", topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.topic_show_path(conn, :show, topic))

      assert html =~ "Topic updated successfully"
      assert html =~ "some updated description"
    end
  end
end
