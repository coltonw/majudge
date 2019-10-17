defmodule Majudge.SleepRDS.KeepAlivePlug do
  alias Majudge.SleepRDS.KeepAlive

  def init(opts), do: opts

  def call(conn, _opts) do
    KeepAlive.ping()
    conn
  end
end
