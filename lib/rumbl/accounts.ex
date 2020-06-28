defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context
  """

  # Allow use of User instead of full context
  alias Rumbl.Accounts.User

  def list_users do
    [
      %User{id: "1", name: "José" , username: "josevalim"     },
      %User{id: "2", name: "Chris", username: "chrismccords"  },
      %User{id: "3", name: "Joe"  , username: "joearmstrong"  },
      %User{id: "4", name: "Lucas", username: "lucaspaszinski"}
    ]
  end

  def get_user(id) do
    list_users()
    |> Enum.find(fn map -> map.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn user ->
      Enum.all?(
        params,
        fn {key, value} -> Map.get(user, key) == value end)
    end)
  end
end
