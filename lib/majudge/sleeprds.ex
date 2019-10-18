# So, I am thinking we have 3 modules, 1 that spins up tasks which communicate with aws and
# 1 that keeps track of how long since the last user activity and one repeating task
# that polls and pings the state tracker and stops the db if there has been no activity for an hour
# then we need a plug that sends a message to the last activity to tell it that there has been more activity
# and then a channel which tells the site when postgres is up
defmodule Majudge.SleepRDS do
  require Logger
  alias Majudge.SleepRDS.StartDB
  alias Majudge.SleepRDS.StopDB

  @doc """
  Starts a task which starts the db instance.
  """
  def start_db() do
    Logger.info("Starting DB")
    DynamicSupervisor.start_child(Majudge.SleepRDSSupervisor, StartDB)
    DynamicSupervisor.start_child(Majudge.SleepRDSSupervisor, Majudge.Repo)
  end

  @doc """
  Starts a task which stops the db instance.
  """
  def stop_db() do
    Logger.info("Stopping DB")
    pid = Process.whereis(Majudge.Repo)

    if pid, do: DynamicSupervisor.terminate_child(Majudge.SleepRDSSupervisor, pid)

    DynamicSupervisor.start_child(Majudge.SleepRDSSupervisor, StopDB)
  end
end
