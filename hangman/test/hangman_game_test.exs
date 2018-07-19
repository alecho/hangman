defmodule HangmanGameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns struct" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "letters is only lowercase alpha characters" do
    game = Game.new_game()

    assert game.letters
    |> Enum.join
    |> String.match?(~r/[a-z]./)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    moves = [
      {"w", :good_guess, 7},
      {"w", :already_used, 7}
    ]
    assert_moves(moves, Game.new_game("widget"))
  end

  test "a good guess is recognized" do
    game = Game.new_game("widget")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a good guess can win the game" do
    moves = [
      {"w", :good_guess, 7},
      {"i", :good_guess, 7},
      {"d", :good_guess, 7},
      {"g", :good_guess, 7},
      {"e", :good_guess, 7},
      {"t", :won, 7},
    ]
    assert_moves(moves, Game.new_game("widget"))
  end

  test "a bad guess is regocnized" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"f", :bad_guess, 3},
      {"h", :bad_guess, 2},
      {"j", :bad_guess, 1},
      {"k", :lost, 0},
    ]
    assert_moves(moves, Game.new_game("w"))
  end

  def assert_moves(moves,game) do
    Enum.reduce(moves, game, fn({guess, state, turns_left}, new_game) ->
      assert new_game = %{
        game_state: ^state,
        turns_left: ^turns_left
      } = Game.make_move(new_game, guess)
      new_game
    end)
  end
end

