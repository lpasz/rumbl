defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  # Register values for valid user and invalid user
  describe "register_user/1" do
  @valid_attrs %{
    name: "User",
    username: "eva",
    password: "secret",
  }

  @invalid_attrs %{}
  end

  test "with valid data inserts user" do
    # confirmes that the user have been successfully created
    # and save "id" and "user"
    assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)

    # Confirmes that the data of user is equal to the one
    # in "@valid_user".
    assert user.name == "User"
    assert user.username == "eva"

    # confirmes that the list of all user contains a user
    # with id of the register user returned
    assert [%User{id: ^id}] = Accounts.list_users()
  end

  test "with invalid data does not insert" do
    # try to register a invalid user and confirmes that return error
    assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)

    # confirmes that no user was added
    assert Accounts.list_users() == []
  end

  test "enforce unique username" do
    # Register valid user
    assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
    # Register valid user again, now expect error
    assert {:error, changeset} = Accounts.register_user(@valid_attrs)
    # Get the error from change set, should be on username
    assert %{username: ["has already been taken"]} = errors_on(changeset)
    # Assert that the first user was correctly added
    assert [%User{id: ^id}] = Accounts.list_users
  end

  test "does not accept long usernames" do
    # put an invalid username on "@valid_user" replacing the valid one
    attrs = Map.put @valid_attrs, :username, String.duplicate("a",30)
    # should be an error
    {:error, changeset} = Accounts.register_user(attrs)
    # retrieve error and should be the too long username
    assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
    # no user should have been added
    assert Accounts.list_users() == []
  end

  test "requires password to be at least 6 chars long" do
    # put too short password on "@valid_user" overriding the valid
    attrs = Map.put @valid_attrs, :password, "12345"
    # error should be returned
    assert {:error, changeset} = Accounts.register_user(attrs)
    # check for the expected error
    assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    #nothing should have been added
    assert Accounts.list_users == []
  end
end
