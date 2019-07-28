defmodule MajudgeWeb.Router do
  use MajudgeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MajudgeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/tally", TallyController, :index

    resources "/ballots", BallotController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MajudgeWeb do
  #   pipe_through :api
  # end
end
