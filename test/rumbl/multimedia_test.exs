defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Multimedia.Category
  alias Multimedia.Video

  describe "categories" do
    test "list_alphabetical_categories" do
      # ["Drama", "Comedy", "Action"] ==  ~w(Drama Comedy Action)
      for name <- ~w(Drama Comedy Action) do
        Multimedia.create_category!(name)
      end

      alphabetical? =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories(),
            do: name

      assert alphabetical? == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    @valid_attrs %{
      description: "my description",
      title: "title",
      url: "http://localhost:42"
    }

    @invalid_attrs %{
      description: nil,
      title: nil,
      url: nil
    }

    test "list_videos/0 returns all videos" do
      owner = user_fixture()

      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()

      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner)

      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      owner = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)

      assert video.description == "my description"
      assert video.title == "title"
      assert video.url == "http://localhost:42"
    end
  end
end
