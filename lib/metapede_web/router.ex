defmodule MetapedeWeb.Router do
  use MetapedeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MetapedeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", MetapedeWeb do
    pipe_through :browser

    get "/tester", TopicController, :index, as: :topic_controller

    live "/time_periods", TimePeriodLive.Index, :main
    live "/time_periods/search", TimePeriodLive.Index, :search
    live "/time_periods/:id/confirm", TimePeriodLive.Index, :confirm

    live "/time_periods/show/:id", TimePeriodLive.Show, :show
    live "/time_periods/show/:id/search", TimePeriodLive.Show, :search
    live "/time_periods/show/:id/confirm", TimePeriodLive.Show, :confirm

    live "/topics", TopicLive.Topics, :topics
    live "/topics/new", TopicLive.Topics, :new
    live "/topics/:id/edit", TopicLive.Topics, :edit

    live "/topics/search", TopicLive.Topics, :search
    live "/topics/review", TopicLive.Topics, :review

    live "/topics/:id", TopicLive.Show, :show
    live "/topics/:id/search", TopicLive.Show, :search
    live "/topics/:id/show/edit", TopicLive.Show, :edit
    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MetapedeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MetapedeWeb.Telemetry
    end
  end
end
