defmodule WordualWeb.Live.KeyboardComponent do
  use Phoenix.Component

  alias Wordual.KeyboardHints

  def show(assigns) do
    assigns = %{
      row_one: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
      row_two: ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
      row_three: ["Enter", "Z", "X", "C", "V", "B", "N", "M", "Backspace"],
      hints: assigns.game.keyboard_hints
    }

    ~H"""
    <div class="keyboard">
      <div class="row">
      <%= for key <- @row_one do %>
        <button class={class(key, @hints)} phx-click="key_down" phx-value-key={key}>
          <%= key %>
        </button>
      <% end %>
      </div>
      <div class="row">
        <div class="half"></div>
        <%= for key <- @row_two do %>
          <button class={class(key, @hints)} phx-click="key_down" phx-value-key={key}>
            <%= key %>
          </button>
        <% end %>
        <div class="half"></div>
      </div>
      <div class="row">
      <%= for key <- @row_three do %>
        <button class={class(key, @hints)} phx-click="key_down" phx-value-key={key}>
          <%= key %>
        </button>
      <% end %>
      </div>
    </div>
    """
  end

  defp class(key, hints) do
    hint =
      case KeyboardHints.for(hints, String.downcase(key)) do
        nil -> ""
        h -> Atom.to_string(h)
      end

    case key do
      "Enter" -> "one-and-a-half text-xs #{hint}"
      "Backspace" -> "one-and-a-half text-xs #{hint}"
      _ -> "#{hint}"
    end
  end
end
