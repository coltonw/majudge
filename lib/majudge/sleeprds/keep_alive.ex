defmodule Majudge.SleepRDS.KeepAlive do
  use GenServer

  alias Majudge.SleepRDS

  @impl true
  def init(:ok) do
    {:ok, DateTime.utc_now()}
  end

  def start_link(_arg) do
    Process.send_after(Majudge.SleepRDS.KeepAlive, :check_date, 1_000)
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def handle_cast(:ping, _state) do
    SleepRDS.start_db()
    {:noreply, DateTime.utc_now()}
  end

  @impl true
  def handle_info(:check_date, last_ping) do
    # 3,600 seconds AKA 1 hour
    if DateTime.diff(DateTime.utc_now(), last_ping) > 3_600 do
      SleepRDS.stop_db()
    end

    # 600,000 millis AKA 10 minutes
    Process.send_after(Majudge.SleepRDS.KeepAlive, :check_date, 600_000)
    {:noreply, last_ping}
  end

  def ping do
    # Process.registered()
    # |> Enum.each(
    #   &if String.starts_with?(Atom.to_string(&1), "Elixir.Majudge"), do: IO.inspect(&1)
    # )

    GenServer.cast(Majudge.SleepRDS.KeepAlive, :ping)
  end
end
