defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase, async: true

  describe "with no one logged" do
    test "require user auth on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.video_path(conn, :new)),
          get(conn, Routes.video_path(conn, :index)),
          get(conn, Routes.video_path(conn, :show, "1 2 3")),
          get(conn, Routes.video_path(conn, :edit, "1 2 3")),
          put(conn, Routes.video_path(conn, :update, "1 2 3")),
          post(conn, Routes.video_path(conn, :create, %{})),
          delete(conn, Routes.video_path(conn, :delete, "1 2 3", %{}))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "with a logged in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    # Need the specified tag for work
    @tag login_as: "max"
    test "list all user's videos on index", %{conn: conn, user: user} do
      user_video =
        video_fixture(
          user,
          title: "funny cats"
        )

      other_video =
        video_fixture(
          user_fixture(username: "other"),
          title: "another_video"
        )

      conn = get(conn, Routes.video_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Listing Videos/
      assert String.contains?(conn.resp_body, user_video.title)
      refute String.contains?(conn.resp_body, other_video.title)
    end

    alias Rumbl.Multimedia

    @create_attrs %{
      url: "http://youtu.be",
      title: "the vid",
      description: "the goddam vid"
    }

    @invalid_attrs %{
      title: "invalid"
    }

    defp video_count, do: Enum.count(Multimedia.list_videos())

    @tag login_as: "max"
    test "create user then video and redirects", %{conn: conn, user: user} do
      # post/create new video
      create_conn = post conn, Routes.video_path(conn, :create), video: @create_attrs
      # assert has an id
      assert %{id: id} = redirected_params(create_conn)
      # asser that you have denn redirected to show the video
      assert redirected_to(create_conn) == Routes.video_path(create_conn, :show, id)
      # get show the video with specific id
      conn = get(conn, Routes.video_path(conn, :show, id))
      # assert html page is show video
      assert html_response(conn, 200) =~ "Show Video"
      # Check if user if is the same of the user that created the video
      assert Multimedia.get_video!(id).user_id == user.id
    end

    @tag login_as: "max"
    test "does not create vid, renders error when invalid", %{conn: conn} do
      # Get the number of videos of user before operation
      count_before = video_count()
      # Try to create a video, but with invalid params
      conn = post conn, Routes.video_path(conn, :create), video: @invalid_attrs
      # Assert html reponse was valid, but show the errors
      assert html_response(conn, 200) =~ "check the errors"
      # Confirmes that no video was actually added
      assert video_count() == count_before
    end
  end

    test "non owner cannot perform any action with video", %{conn: conn} do
      # Create and add user
      owner = user_fixture(username: "owner")
      # Create and add video to previous user
      video = video_fixture(owner, @create_attrs)
      # Create a new user to check if can acess the owner videos
      non_owner = user_fixture(username: "sneaky")
      # Loggin the non_owner of the video user
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent(
        :not_found,
        fn ->
          get(conn, Routes.video_path(conn, :show, video))
        end
      )

      assert_error_sent(
        :not_found,
        fn ->
          get(conn, Routes.video_path(conn, :edit, video))
        end
      )

      assert_error_sent(
        :not_found,
        fn ->
          put(conn, Routes.video_path(conn, :update, video, video: @create_attrs))
        end
      )

      assert_error_sent(
        :not_found,
        fn ->
          delete(conn, Routes.video_path(conn, :delete, video))
        end
      )
    end
end
