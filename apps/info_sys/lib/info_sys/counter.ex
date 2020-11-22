defmodule InfoSys.Counter do
  use GenServer

  def inc(pid \\ __MODULE__) do
    GenServer.cast(pid, :inc)
  end

  def dec(pid \\ __MODULE__) do
    GenServer.cast(pid, :dec)
  end

  def val(pid \\ __MODULE__) do
    GenServer.call(pid, :val)
  end

  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val, name: __MODULE__)
  end

  def init(initial_val) do
    Process.send_after(self(), :tick, 1000)
    {:ok, initial_val}
  end

  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end

  def handle_info(:tick, val) when val <= 0 do
    raise("boom-sakalaka!")
  end

  def handle_info(:tick, val) do
    IO.puts("tick #{val}")
    Process.send_after(self(), :tick, 1000)
    {:noreply, val - 1}
  end
end
