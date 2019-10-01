defmodule Majudge.SleepRDS.StopDB do
  use Task

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    # ExAws...
  end
end
