defmodule TextClient.Player do
  require IEx

  alias TextClient.{Mover, Prompter, State, Summary}

  def play(%State{tally: %{ game_state: :won, letters: letters }}) do
    "You WON! \"" <> Enum.join(letters, "") <> "\""
    |> exit_with_message()
  end

  def play(%State{tally: %{ game_state: :lost, letters: letters }}) do
    "Sorry, you lost. The word was: " <> Enum.join(letters, "")
    |> exit_with_message()
  end

  def play(game = %State{tally: %{ game_state: :good_guess }}) do
    game
    |> continue_with_message("Good guess!")
  end

  def play(game = %State{tally: %{ game_state: :bad_guess }}) do
    game
    |> continue_with_message("Sorry, that isn't in the word")
  end

  def play(game = %State{tally: %{ game_state: :already_used }}) do
    game
    |> continue_with_message("That letter has already been guessed")
  end

  def play(game) do
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  def display(game) do
    continue(game)
  end

  def prompt(game) do
    continue(game)
  end

  def make_move(game) do
    continue(game)
  end

  defp continue_with_message(game, msg) do
    IO.puts(msg);
    continue(game)
  end

  defp exit_with_message(msg) do
    IO.puts(msg);
    exit(:normal)
  end

end
