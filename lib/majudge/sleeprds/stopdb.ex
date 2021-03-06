defmodule Majudge.SleepRDS.StopDB do
  require Logger
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

    case ExAws.request(operation) do
      {:ok, _} ->
        Logger.info("Stopped AWS RDS")

      {:error, {_err_name, _err_code, resp}} ->
        # ignore errors where RDS is already stopped
        unless resp.body =~ "InvalidDBInstanceState" do
          Logger.error(resp.body)
        end
    end
  end
end
