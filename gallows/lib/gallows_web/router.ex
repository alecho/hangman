defmodule GallowsWeb.Router do
  use GallowsWeb, :router

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

  scope "/hangman", GallowsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HangmanController, :new_game
    post "/", HangmanController, :create_game
    put "/", HangmanController, :make_move
  end

  # Other scopes may use custom stacks.
  # scope "/api", GallowsWeb do
  #   pipe_through :api
  # end
end
