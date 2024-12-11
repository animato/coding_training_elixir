defmodule CodingTrainingElixirWeb.Router do
  use CodingTrainingElixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CodingTrainingElixirWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CodingTrainingElixirWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/chapter2", Chapter2Live
    live "/chapter3", Chapter3Live
    live "/chapter5", Chapter5Live
    live "/chapter6", Chapter6Live
    live "/chapter7", Chapter7Live
    live "/chapter8", Chapter8Live
    live "/chapter9", Chapter9Live
    live "/chapter10", Chapter10Live
    live "/chapter11", Chapter11Live
    live "/chapter12", Chapter12Live
    live "/chapter13", Chapter13Live
    live "/chapter14", Chapter14Live
    live "/chapter15", Chapter15Live
    live "/chapter16", Chapter16Live
    live "/chapter18", Chapter18Live
    live "/chapter19", Chapter19Live
    live "/chapter21", Chapter21Live
    live "/chapter24", Chapter24Live
    live "/chapter25", Chapter25Live
    live "/chapter27", Chapter27Live
    live "/chapter31", Chapter31Live
    live "/chapter32", Chapter32Live
    live "/chapter35", Chapter35Live
    live "/chapter37", Chapter37Live
  end

  # Other scopes may use custom stacks.
  # scope "/api", CodingTrainingElixirWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:coding_training_elixir, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CodingTrainingElixirWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
