defmodule InfoSys.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Supervisor, as: Sup

  def start(_type, _args) do
    # Starts a worker by calling: InfoSys.Worker.start_link(arg)
    children = [
      Sup.child_spec({InfoSys.Counter, 5}, id: :short),
      Sup.child_spec({InfoSys.Counter, 15}, id: :medium),
      Sup.child_spec({InfoSys.Counter, 45}, id: :long)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InfoSys.Supervisor]
    Sup.start_link(children, opts)
  end
end
