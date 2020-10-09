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
      # get user mock
      owner = user_fixture()

      # get video mock
      %Video{id: id1} = video_fixture(owner)
      # assert that the only that video was on the list
      assert [%Video{id: ^id1}] = Multimedia.list_videos()

      # get video mock
      %Video{id: id2} = video_fixture(owner)
      # assert that both video were on the list
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id" do
      # get user mock
      owner = user_fixture()
      # get video mock
      %Video{id: id} = video_fixture(owner)

      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      # get user mock
      owner = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)

      assert video.description == "my description"
      assert video.title == "title"
      assert video.url == "http://localhost:42"
    end

    test "create_video/2 with invalid data return error" do
      # get user mock
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data update the video" do
      # get user mock
      owner = user_fixture()
      # get video mock
      video = video_fixture(owner)

      assert {:ok, video} = Multimedia.update_video(video, %{title: "update title"})
      assert %Video{} = video
      assert video.title == "update title"
    end

    test "update_video/2 with invalid data return error changeset" do
      # get user mock
      owner = user_fixture()
      # get video mock
      %Video{id: id} = video = video_fixture(owner)

      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "delete_video/1 deletes the video" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert [] == Multimedia.list_videos()
    end

    test "change_video/1 returns a video changeset" do
      owner = user_fixture()
      video = video_fixture(owner)
      # careful with your equal sign, double is note pattern matching (D:)
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end
