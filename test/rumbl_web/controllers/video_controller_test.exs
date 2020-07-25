defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase, async: true

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
