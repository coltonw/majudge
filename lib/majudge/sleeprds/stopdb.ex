defmodule Majudge.SleepRDS.StopDB do
  use Task

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    query_params = %{
      Action: "StopDBInstance",
      DBInstanceIdentifier: "majudge-db-1",
      Version: "2014-10-31"
    }

    operation = %ExAws.Operation.Query{
      path: "/",
      params: query_params,
      service: :rds
    }

    ExAws.request(operation)
  end
end
