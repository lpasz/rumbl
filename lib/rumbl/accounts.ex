defmodule Accounts do
  @moduledoc """
  The Accounts context
  """

  alias Rumbl.Accounts.User

  def list_users do
    [
      %User{  id: "1", name: "José" ,  username: "josevalim"      },
      %User{  id: "2", name: "Chris",  username: "chrismccords"   },
      %User{  id: "3", name: "Joe"  ,  username: "joearmstrong"   },
      %User{  id: "4", name: "Lucas",  username: "lucaspaszinski" },
    ]
  end
end
