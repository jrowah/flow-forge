defmodule FlowForgeWeb.Components.Rating do
  @moduledoc """
  The `FlowForgeWeb.Components.Rating` module provides a versatile rating component for Phoenix LiveView
  applications. This component is designed to display a configurable number of rating stars with
  customizable colors, sizes, and interactive capabilities.

  The `Rating` component supports both static and interactive modes. In static mode,
  the stars represent a pre-defined rating value, while in interactive mode, users can select a
  rating by clicking on the stars. It offers a range of customization options such as gap size,
  star color, and size, making it suitable for various user interfaces where feedback or ratings are required.

  This component is ideal for implementing user reviews, feedback forms, and any other scenario where
  a visual rating system is needed. Its flexibility and ease of integration make it a powerful
  tool for enhancing the user experience in Phoenix LiveView applications.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  use Gettext, backend: FlowForgeWeb.Gettext

  @doc """
  Renders a `rating` component using stars to represent a score or rating value.
  The component supports interactive and non-interactive modes, making it suitable
  for both display and user input scenarios.

  ## Examples

  ```elixir
  <.rating interactive />
  <.rating color="primary" gap="large" interactive />
  <.rating color="danger" gap="extra_large" select={5} interactive />
  <.rating color="success" gap="extra_large" select={3} interactive />
  ```
  """
  @doc type: :component
  attr :id, :string,
    default: nil,
    doc: "A unique identifier is used to manage state and interaction"

  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"
  attr :gap, :string, default: "small", doc: "Custom gap style"

  attr :size, :string,
    default: "small",
    doc:
      "Determines the overall size of the elements, including padding, font size, and other items"

  attr :color, :string, default: "warning", doc: "Determines color theme"
  attr :count, :integer, default: 5, doc: "Number of stars to display"
  attr :select, :any, default: 0, doc: "Integer or float value for selected stars"

  attr :params, :map,
    default: %{},
    doc: "A map of additional parameters used for element configuration"

  attr :on_action, JS, default: %JS{}, doc: "Custom JS module for on_action action"

  attr :interactive, :boolean,
    default: false,
    doc: "If true, stars are wrapped in a button for selecting a rating"

  attr :rest, :global,
    doc:
      "Global attributes can define defaults which are merged with attributes provided by the caller"

  def rating(assigns) do
    ~H"""
    <div
      id={@id}
      role="radiogroup"
      class={[
        "flex flex-nowrap text-[#F4F4F4] dark:text-[#4B4B4B]",
        gap_class(@gap),
        size_class(@size),
        color_class(@color),
        @class
      ]}
      {@rest}
    >
      <%= for item <- 1..@count do %>
        <% fill_percentage = calculate_fill_percentage(item, @select) %>
        <%= if @interactive do %>
          <button
            role="radio"
            aria-checked={if item <= @select, do: "true", else: "false"}
            tabindex={if item == @select, do: "0", else: "-1"}
            aria-label={"#{item} star#{if item > 1, do: "s", else: ""}"}
            class={[
              "rating-button",
              "leading-5",
              "group",
              "[&:has(~.rating-button:hover)_.fraction-path]:opacity-0 [&:has(~.rating-button:hover)_.full-path]:opacity-100"
            ]}
            phx-click={
              @on_action
              |> JS.push("rating", value: Map.merge(%{action: "select", number: item}, @params))
            }
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              class={["rating-icon transition-all delay-100", fill_percentage > 0 && "rated"]}
            >
              <%= if fill_percentage > 0 and fill_percentage < 100 do %>
                <defs>
                  <linearGradient id={"star-fill-#{@id}-#{item}"} x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stop-color="currentColor"></stop>
                    <stop offset={"#{fill_percentage}%"} stop-color="currentColor"></stop>
                    <stop offset={"#{fill_percentage}%"} stop-color="currentColor" stop-opacity="0.2">
                    </stop>
                    <stop offset="100%" stop-color="currentColor" stop-opacity="0.2"></stop>
                  </linearGradient>
                </defs>
                <path
                  class="opacity-100 transition-all delay-100 group-hover:opacity-0 fraction-path"
                  fill={"url(#star-fill-#{@id}-#{item})"}
                  d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z"
                />
                <path
                  class="opacity-0 transition-all delay-100 group-hover:opacity-100 full-path"
                  fill="currentColor"
                  d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z"
                />
              <% else %>
                <path
                  fill="currentColor"
                  class={[
                    fill_percentage >= 100 && "fill-opacity-100",
                    fill_percentage < 100 && "fill-opacity-20"
                  ]}
                  d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z"
                />
              <% end %>
            </svg>
            <span class="sr-only">{gettext("Rate %{count} star", count: item)}</span>
          </button>
        <% else %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            class={["rating-icon transition-all delay-100", fill_percentage > 0 && "rated"]}
          >
            <%= if fill_percentage > 0 and fill_percentage < 100 do %>
              <defs>
                <linearGradient id={"star-fill-#{@id}-#{item}"} x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" stop-color="currentColor"></stop>
                  <stop offset={"#{fill_percentage}%"} stop-color="currentColor"></stop>
                  <stop offset={"#{fill_percentage}%"} stop-color="currentColor" stop-opacity="0.2">
                  </stop>
                  <stop offset="100%" stop-color="currentColor" stop-opacity="0.2"></stop>
                </linearGradient>
              </defs>
              <path
                fill={"url(#star-fill-#{@id}-#{item})"}
                d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z"
              />
            <% else %>
              <path
                fill="currentColor"
                class={[
                  fill_percentage >= 100 && "fill-opacity-100",
                  fill_percentage < 100 && "fill-opacity-20"
                ]}
                d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z"
              />
            <% end %>
          </svg>
        <% end %>
      <% end %>
    </div>
    """
  end

  # Helper function to calculate the fill percentage for a star
  defp calculate_fill_percentage(star_position, select) do
    cond do
      # For integer values or when select is not a number, use the original behavior
      not is_float(select) or abs(select - trunc(select)) < 0.001 ->
        if star_position <= select, do: 100, else: 0

      # For decimal values (3.1 to 3.9 would render as 3.5)
      star_position <= floor(select) ->
        100

      star_position == ceil(select) and select - floor(select) >= 0.1 ->
        50

      true ->
        0
    end
  end

  defp gap_class("extra_small"), do: "gap-1"
  defp gap_class("small"), do: "gap-1.5"
  defp gap_class("medium"), do: "gap-2"
  defp gap_class("large"), do: "gap-2.5"
  defp gap_class("extra_large"), do: "gap-3"
  defp gap_class("none"), do: nil
  defp gap_class(params) when is_binary(params), do: params

  defp size_class("extra_small"), do: "[&_.rating-icon]:size-4"

  defp size_class("small"), do: "[&_.rating-icon]:size-5"

  defp size_class("medium"), do: "[&_.rating-icon]:size-6"

  defp size_class("large"), do: "[&_.rating-icon]:size-7"

  defp size_class("extra_large"), do: "[&_.rating-icon]:size-8"

  defp size_class("double_large"), do: "[&_.rating-icon]:size-9"

  defp size_class("triple_large"), do: "[&_.rating-icon]:size-10"

  defp size_class("quadruple_large"), do: "[&_.rating-icon]:size-11"

  defp size_class(params) when is_binary(params), do: params

  defp color_class("base") do
    [
      "[&_.rated]:text-[#e4e4e7] dark:[&_.rated]:text-[#27272a]",
      "hover:[&_.rating-button]:text-[#e4e4e7] [&_.rating-button:has(~.rating-button:hover)]:text-[#e4e4e7]",
      "dark:hover:[&_.rating-button]:text-[#27272a] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#27272a]"
    ]
  end

  defp color_class("white") do
    [
      "[&_.rated]:text-white hover:[&_.rating-button]:text-white",
      "[&_.rating-button:has(~.rating-button:hover)]:text-white"
    ]
  end

  defp color_class("natural") do
    [
      "[&_.rated]:text-[#4B4B4B] dark:[&_.rated]:text-[#DDDDDD]",
      "hover:[&_.rating-button]:text-[#4B4B4B] [&_.rating-button:has(~.rating-button:hover)]:text-[#4B4B4B]",
      "dark:hover:[&_.rating-button]:text-[#DDDDDD] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#DDDDDD]"
    ]
  end

  defp color_class("primary") do
    [
      "[&_.rated]:text-[#007F8C] dark:[&_.rated]:text-[#01B8CA]",
      "hover:[&_.rating-button]:text-[#007F8C] [&_.rating-button:has(~.rating-button:hover)]:text-[#007F8C]",
      "dark:hover:[&_.rating-button]:text-[#01B8CA] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#01B8CA]"
    ]
  end

  defp color_class("secondary") do
    [
      "[&_.rated]:text-[#266EF1] dark:[&_.rated]:text-[#6DAAFB]",
      "hover:[&_.rating-button]:text-[#266EF1] [&_.rating-button:has(~.rating-button:hover)]:text-[#266EF1]",
      "dark:hover:[&_.rating-button]:text-[#6DAAFB] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#6DAAFB]"
    ]
  end

  defp color_class("success") do
    [
      "[&_.rated]:text-[#0E8345] dark:[&_.rated]:text-[#06C167]",
      "hover:[&_.rating-button]:text-[#0E8345] [&_.rating-button:has(~.rating-button:hover)]:text-[#0E8345]",
      "dark:hover:[&_.rating-button]:text-[#06C167] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#06C167]"
    ]
  end

  defp color_class("warning") do
    [
      "[&_.rated]:text-[#CA8D01] dark:[&_.rated]:text-[#FDC034]",
      "hover:[&_.rating-button]:text-[#CA8D01] [&_.rating-button:has(~.rating-button:hover)]:text-[#CA8D01]",
      "dark:hover:[&_.rating-button]:text-[#FDC034] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#FDC034]"
    ]
  end

  defp color_class("danger") do
    [
      "[&_.rated]:text-[#DE1135] dark:[&_.rated]:text-[#FC7F79]",
      "hover:[&_.rating-button]:text-[#DE1135] [&_.rating-button:has(~.rating-button:hover)]:text-[#DE1135]",
      "dark:hover:[&_.rating-button]:text-[#FC7F79] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#FC7F79]"
    ]
  end

  defp color_class("info") do
    [
      "[&_.rated]:text-[#0B84BA] dark:[&_.rated]:text-[#3EB7ED]",
      "hover:[&_.rating-button]:text-[#0B84BA] [&_.rating-button:has(~.rating-button:hover)]:text-[#0B84BA]",
      "dark:hover:[&_.rating-button]:text-[#3EB7ED] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#3EB7ED]"
    ]
  end

  defp color_class("misc") do
    [
      "[&_.rated]:text-[#8750C5] dark:[&_.rated]:text-[#BA83F9]",
      "hover:[&_.rating-button]:text-[#8750C5] [&_.rating-button:has(~.rating-button:hover)]:text-[#8750C5]",
      "dark:hover:[&_.rating-button]:text-[#BA83F9] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#BA83F9]"
    ]
  end

  defp color_class("dawn") do
    [
      "[&_.rated]:text-[#A86438] dark:[&_.rated]:text-[#DB976B]",
      "hover:[&_.rating-button]:text-[#A86438] [&_.rating-button:has(~.rating-button:hover)]:text-[#A86438]",
      "dark:hover:[&_.rating-button]:text-[#DB976B] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#DB976B]"
    ]
  end

  defp color_class("silver") do
    [
      "[&_.rated]:text-[#868686] dark:[&_.rated]:text-[#A6A6A6]",
      "hover:[&_.rating-button]:text-[#868686] [&_.rating-button:has(~.rating-button:hover)]:text-[#868686]",
      "dark:hover:[&_.rating-button]:text-[#A6A6A6] dark:[&_.rating-button:has(~.rating-button:hover)]:text-[#A6A6A6]"
    ]
  end

  defp color_class("dark") do
    [
      "[&_.rated]:text-[#282828]",
      "hover:[&_.rating-button]:text-[#282828] [&_.rating-button:has(~.rating-button:hover)]:text-[#282828]"
    ]
  end

  defp color_class(params) when is_binary(params), do: params
end
