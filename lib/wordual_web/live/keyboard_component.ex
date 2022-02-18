defmodule WordualWeb.Live.KeyboardComponent do
  use Phoenix.Component

  def show(_assigns) do
    assigns = %{
      row_one: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
      row_two: ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
      row_three: ["Enter", "Z", "X", "C", "V", "B", "N", "M", "Backspace"]
    }

    ~H"""
    <div class="keyboard">
      <div class="row">
      <%= for key <- @row_one do %>
        <button phx-click="key_down" phx-value-key={key}>
          <%= key %>
        </button>
      <% end %>
      </div>
      <div class="row">
        <div class="half"></div>
        <%= for key <- @row_two do %>
          <button phx-click="key_down" phx-value-key={key}>
            <%= key %>
          </button>
        <% end %>
        <div class="half"></div>
      </div>
      <div class="row">
      <%= for key <- @row_three do %>
        <button class={class(key)} phx-click="key_down" phx-value-key={key}>
          <%= key %>
        </button>
      <% end %>
      </div>
    </div>
    """
  end

  defp class(key) do
    case key do
      "Enter" -> "one-and-a-half text-xs"
      "Backspace" -> "one-and-a-half text-xs"
      _ -> ""
    end
  end
end
