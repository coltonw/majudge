ExUnit.start()
DynamicSupervisor.start_child(Majudge.SleepRDSSupervisor, Majudge.Repo)
Ecto.Adapters.SQL.Sandbox.mode(Majudge.Repo, :manual)
