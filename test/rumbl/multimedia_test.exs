defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Multimedia.Category

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
end
