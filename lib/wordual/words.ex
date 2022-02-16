defmodule Wordual.Words do
  def random_word do
    game_words()
    |> Enum.random()
  end

  def valid_word?(word) do
    Enum.any?(all_words(), &(&1 == word))
  end

  defp game_words do
    Keyword.get(config(), :game_words)
  end

  defp all_words do
    Keyword.get(config(), :choice_words) ++ game_words()
  end

  defp config do
    Application.fetch_env!(:wordual, __MODULE__)
  end
end
