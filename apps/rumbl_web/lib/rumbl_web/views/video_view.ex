defmodule RumblWeb.VideoView do
  use RumblWeb, :view

  def category_select_options(categories) do
    Enum.map(categories, &{&1.name, &1.id})
  end
end
