defmodule Rumbl do
  @moduledoc """
  Rumbl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others
  """

  @doc """
   ## Examples

      iex> Rumbl.who_am_i
      :rumbl
  """
  def who_am_i, do: :rumbl
end
