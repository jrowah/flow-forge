defmodule FlowForgeWeb.Components.Footer do
  @moduledoc """
  The `FlowForgeWeb.Components.Footer` module provides a customizable footer component for Phoenix applications,
  allowing for various styles, colors, and layout options. It supports different design variants
  such as default, outline, transparent, shadow, and unbordered.

  ### Features:

  - **Customizable Styles:** Choose from multiple color themes and design variants.
  - **Flexible Layouts:** Control text positioning, spacing, padding, and border styles.
  - **Responsive Design:** Set max width and rounded corners for adaptive layouts.
  - **Global Attributes Support:** Allows for additional attributes to be merged with component defaults.

  This component is designed to enhance the appearance and functionality of footers in web applications.
  """

  use Phoenix.Component

  @doc """
  Renders a customizable `footer` component with different sections and styling options, allowing
  for the inclusion of text, links, and other content.

  ## Examples

  ```elixir
  <.footer color="secondary" padding="large" space="medium">
    <.footer_section class="border-b" padding="small">Mishka Chelekom</.footer_section>

    <.footer_section class="grid grid-cols-3 gap-2 justify-between" padding="large">
      <.list color="secondary">
        <:item><a href="/">Home</a></:item>
        <:item><a href="/">Contact</a></:item>
        <:item><a href="/">About</a></:item>
      </.list>

      <.list color="secondary" style="list-disc">
        <:item>list</:item>
        <:item>list</:item>
        <:item>list</:item>
      </.list>

      <div>
        Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an
        unknown printer took a galley of type and scrambled it to make a type specimen bookged.
      </div>
    </.footer_section>

    <.footer_section text_position="center" class="border-t" padding="small">
      © 2023 Mishka Chelekom
    </.footer_section>
  </.footer>
  ```
  """
  @doc type: :component
  attr :id, :string,
    default: nil,
    doc: "A unique identifier is used to manage state and interaction"

  attr :variant, :string, default: "base", doc: "Determines the style"
  attr :color, :string, default: "natural", doc: "Determines color theme"
  attr :border, :string, default: "extra_small", doc: "Determines border style"
  attr :text_position, :string, default: "", doc: "Determines the element' text position"
  attr :rounded, :string, default: "", doc: "Determines the border radius"
  attr :max_width, :string, default: "", doc: "Determines the style of element max width"
  attr :space, :string, default: "", doc: "Space between items"

  attr :font_weight, :string,
    default: "font-normal",
    doc: "Determines custom class for the font weight"

  attr :padding, :string, default: "", doc: "Determines padding for items"
  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"

  attr :wrapper_class, :string,
    default: nil,
    doc: "Custom CSS class for additional styling to footer content wrapper"

  attr :rest, :global,
    doc:
      "Global attributes can define defaults which are merged with attributes provided by the caller"

  slot :inner_block, required: false, doc: "Inner block that renders HEEx content"

  def footer(assigns) do
    ~H"""
    <footer
      id={@id}
      class={[
        border_class(@border, @variant),
        color_variant(@variant, @color),
        rounded_size(@rounded),
        padding_size(@padding),
        text_position(@text_position),
        maximum_width(@max_width),
        space_class(@space),
        @font_weight,
        @class
      ]}
      {@rest}
    >
      <div class={@wrapper_class}>
        {render_slot(@inner_block)}
      </div>
    </footer>
    """
  end

  @doc """
  Renders a section within a footer component, allowing for customized text alignment, spacing, and styling.

  ## Examples

  ```elixir
  <.footer_section class="border-b" padding="small">Mishka Chelekom</.footer_section>
  ```
  """
  @doc type: :component
  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"

  attr :font_weight, :string,
    default: "font-normal",
    doc: "Determines custom class for the font weight"

  attr :text_position, :string, default: "", doc: "Determines the element' text position"
  attr :space, :string, default: "", doc: "Space between items"
  attr :padding, :string, default: "", doc: "Determines padding for items"
  slot :inner_block, required: false, doc: "Inner block that renders HEEx content"

  def footer_section(assigns) do
    ~H"""
    <div class={[
      padding_size(@padding),
      text_position(@text_position),
      space_class(@space),
      @font_weight,
      @class
    ]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp text_position("left"), do: "text-left"
  defp text_position("right"), do: "text-right"
  defp text_position("center"), do: "text-center"
  defp text_position(params) when is_binary(params), do: params

  defp space_class("extra_small"), do: "space-y-2"

  defp space_class("small"), do: "space-y-3"

  defp space_class("medium"), do: "space-y-4"

  defp space_class("large"), do: "space-y-5"

  defp space_class("extra_large"), do: "space-y-6"

  defp space_class(params) when is_binary(params), do: params

  defp maximum_width("extra_small"), do: "[&>div]:max-w-3xl	[&>div]:mx-auto"
  defp maximum_width("small"), do: "[&>div]:max-w-4xl [&>div]:mx-auto"
  defp maximum_width("medium"), do: "[&>div]:max-w-5xl [&>div]:mx-auto"
  defp maximum_width("large"), do: "[&>div]:max-w-6xl [&>div]:mx-auto"
  defp maximum_width("extra_large"), do: "[&>div]:max-w-7xl [&>div]:mx-auto"
  defp maximum_width(params) when is_binary(params), do: params

  defp padding_size("extra_small"), do: "p-1"

  defp padding_size("small"), do: "p-2"

  defp padding_size("medium"), do: "p-3"

  defp padding_size("large"), do: "p-4"

  defp padding_size("extra_large"), do: "p-5"

  defp padding_size(params) when is_binary(params), do: params

  defp border_class(_, variant) when variant in ["default", "shadow", "transparent", "gradient"],
    do: nil

  defp border_class("none", _), do: "border-t-0"
  defp border_class("extra_small", _), do: "border-t"
  defp border_class("small", _), do: "border-t-2"
  defp border_class("medium", _), do: "border-t-[3px]"
  defp border_class("large", _), do: "border-t-4"
  defp border_class("extra_large", _), do: "border-t-[5px]"
  defp border_class(params, _) when is_binary(params), do: params

  defp rounded_size("extra_small"), do: "rounded-t-sm"

  defp rounded_size("small"), do: "rounded-t"

  defp rounded_size("medium"), do: "rounded-t-md"

  defp rounded_size("large"), do: "rounded-t-lg"

  defp rounded_size("extra_large"), do: "rounded-t-xl"

  defp rounded_size(params) when is_binary(params), do: params

  defp color_variant("base", _) do
    [
      "bg-white text-[#09090b] border-[#e4e4e7]",
      "dark:bg-[#18181B] dark:text-[#FAFAFA] dark:border-[#27272a]"
    ]
  end

  defp color_variant("default", "white") do
    [
      "bg-white text-black"
    ]
  end

  defp color_variant("default", "dark") do
    [
      "bg-[#282828] text-white"
    ]
  end

  defp color_variant("default", "natural") do
    [
      "bg-[#4B4B4B] text-white dark:bg-[#DDDDDD] dark:text-black"
    ]
  end

  defp color_variant("default", "primary") do
    [
      "bg-[#007F8C] text-white dark:bg-[#01B8CA] dark:text-black"
    ]
  end

  defp color_variant("default", "secondary") do
    [
      "bg-[#266EF1] text-white dark:bg-[#6DAAFB] dark:text-black"
    ]
  end

  defp color_variant("default", "success") do
    [
      "bg-[#0E8345] text-white dark:bg-[#06C167] dark:text-black"
    ]
  end

  defp color_variant("default", "warning") do
    [
      "bg-[#CA8D01] text-white dark:bg-[#FDC034] dark:text-black"
    ]
  end

  defp color_variant("default", "danger") do
    [
      "bg-[#DE1135] text-white dark:bg-[#FC7F79] dark:text-black"
    ]
  end

  defp color_variant("default", "info") do
    [
      "bg-[#0B84BA] text-white dark:bg-[#3EB7ED] dark:text-black"
    ]
  end

  defp color_variant("default", "misc") do
    [
      "bg-[#8750C5] text-white dark:bg-[#BA83F9] dark:text-black"
    ]
  end

  defp color_variant("default", "dawn") do
    [
      "bg-[#A86438] text-white dark:bg-[#DB976B] dark:text-black"
    ]
  end

  defp color_variant("default", "silver") do
    [
      "bg-[#868686] text-white dark:bg-[#A6A6A6] dark:text-black"
    ]
  end

  defp color_variant("outline", "natural") do
    [
      "text-[#4B4B4B] border-[#4B4B4B] dark:text-[#DDDDDD] dark:border-[#DDDDDD]"
    ]
  end

  defp color_variant("outline", "primary") do
    [
      "text-[#007F8C] border-[#007F8C]  dark:text-[#01B8CA] dark:border-[#01B8CA]"
    ]
  end

  defp color_variant("outline", "secondary") do
    [
      "text-[#266EF1] border-[#266EF1] dark:text-[#6DAAFB] dark:border-[#6DAAFB]"
    ]
  end

  defp color_variant("outline", "success") do
    [
      "text-[#0E8345] border-[#0E8345] dark:text-[#06C167] dark:border-[#06C167]"
    ]
  end

  defp color_variant("outline", "warning") do
    [
      "text-[#CA8D01] border-[#CA8D01] dark:text-[#FDC034] dark:border-[#FDC034]"
    ]
  end

  defp color_variant("outline", "danger") do
    [
      "text-[#DE1135] border-[#DE1135] dark:text-[#FC7F79] dark:border-[#FC7F79]"
    ]
  end

  defp color_variant("outline", "info") do
    [
      "text-[#0B84BA] border-[#0B84BA] dark:text-[#3EB7ED] dark:border-[#3EB7ED]"
    ]
  end

  defp color_variant("outline", "misc") do
    [
      "text-[#8750C5] border-[#8750C5] dark:text-[#BA83F9] dark:border-[#BA83F9]"
    ]
  end

  defp color_variant("outline", "dawn") do
    [
      "text-[#A86438] border-[#A86438] dark:text-[#DB976B] dark:border-[#DB976B]"
    ]
  end

  defp color_variant("outline", "silver") do
    [
      "text-[#868686] border-[#868686] dark:text-[#A6A6A6] dark:border-[#A6A6A6]"
    ]
  end

  defp color_variant("shadow", "natural") do
    [
      "bg-[#4B4B4B] text-white dark:bg-[#DDDDDD] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(134,134,134,0.5)] shadow-[0px_10px_15px_-3px_rgba(134,134,134,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "primary") do
    [
      "bg-[#007F8C] text-white dark:bg-[#01B8CA] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(0,149,164,0.5)] shadow-[0px_10px_15px_-3px_rgba(0,149,164,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "secondary") do
    [
      "bg-[#266EF1] text-white dark:bg-[#6DAAFB] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(6,139,238,0.5)] shadow-[0px_10px_15px_-3px_rgba(6,139,238,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "success") do
    [
      "bg-[#0E8345] text-white hover:bg-[#166C3B] dark:bg-[#06C167] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(0,154,81,0.5)] shadow-[0px_10px_15px_-3px_rgba(0,154,81,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "warning") do
    [
      "bg-[#CA8D01] text-white dark:bg-[#FDC034] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(252,176,1,0.5)] shadow-[0px_10px_15px_-3px_rgba(252,176,1,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "danger") do
    [
      "bg-[#DE1135] text-white dark:bg-[#FC7F79] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(248,52,70,0.5)] shadow-[0px_10px_15px_-3px_rgba(248,52,70,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "info") do
    [
      "bg-[#0B84BA] text-white dark:bg-[#3EB7ED] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(14,165,233,0.5)] shadow-[0px_10px_15px_-3px_rgba(14,165,233,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "misc") do
    [
      "bg-[#8750C5] text-white dark:bg-[#BA83F9] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(169,100,247,0.5)] shadow-[0px_10px_15px_-3px_rgba(169,100,247,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "dawn") do
    [
      "bg-[#A86438] text-white dark:bg-[#DB976B] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(210,125,70,0.5)] shadow-[0px_10px_15px_-3px_rgba(210,125,70,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("shadow", "silver") do
    [
      "bg-[#868686] text-white dark:bg-[#A6A6A6] dark:text-black",
      "shadow-[0px_4px_6px_-4px_rgba(134,134,134,0.5)] shadow-[0px_10px_15px_-3px_rgba(134,134,134,0.5)] dark:shadow-none"
    ]
  end

  defp color_variant("bordered", "white") do
    [
      "bg-white text-black border-[#DDDDDD]"
    ]
  end

  defp color_variant("bordered", "dark") do
    [
      "bg-[#282828] text-white border-[#727272]"
    ]
  end

  defp color_variant("bordered", "natural") do
    [
      "text-[#282828] border-[#282828] bg-[#F3F3F3]",
      "dark:text-[#E8E8E8] dark:border-[#E8E8E8] dark:bg-[#4B4B4B]"
    ]
  end

  defp color_variant("bordered", "primary") do
    [
      "text-[#016974] border-[#016974] bg-[#E2F8FB]",
      "dark:text-[#77D5E3] dark:border-[#77D5E3] dark:bg-[#002D33]"
    ]
  end

  defp color_variant("bordered", "secondary") do
    [
      "text-[#175BCC] border-[#175BCC] bg-[#EFF4FE]",
      "dark:text-[#A9C9FF] dark:border-[#A9C9FF] dark:bg-[#002661]"
    ]
  end

  defp color_variant("bordered", "success") do
    [
      "text-[#166C3B] border-[#166C3B] bg-[#EAF6ED]",
      "dark:text-[#7FD99A] dark:border-[#7FD99A] dark:bg-[#002F14]"
    ]
  end

  defp color_variant("bordered", "warning") do
    [
      "text-[#976A01] border-[#976A01] bg-[#FFF7E6]",
      "dark:text-[#FDD067] dark:border-[#FDD067] dark:bg-[#322300]"
    ]
  end

  defp color_variant("bordered", "danger") do
    [
      "text-[#BB032A] border-[#BB032A] bg-[#FFF0EE]",
      "dark:text-[#FFB2AB] dark:border-[#FFB2AB] dark:bg-[#520810]"
    ]
  end

  defp color_variant("bordered", "info") do
    [
      "text-[#0B84BA] border-[#0B84BA] bg-[#E7F6FD]",
      "dark:text-[#6EC9F2] dark:border-[#6EC9F2] dark:bg-[#03212F]"
    ]
  end

  defp color_variant("bordered", "misc") do
    [
      "text-[#653C94] border-[#653C94] bg-[#F6F0FE]",
      "dark:text-[#CBA2FA] dark:border-[#CBA2FA] dark:bg-[#221431]"
    ]
  end

  defp color_variant("bordered", "dawn") do
    [
      "text-[#7E4B2A] border-[#7E4B2A] bg-[#FBF2ED]",
      "dark:text-[#E4B190] dark:border-[#E4B190] dark:bg-[#2A190E]"
    ]
  end

  defp color_variant("bordered", "silver") do
    [
      "text-[#727272] border-[#727272] bg-[#F3F3F3]",
      "dark:text-[#BBBBBB] dark:border-[#BBBBBB] dark:bg-[#4B4B4B]"
    ]
  end

  defp color_variant("transparent", "natural") do
    [
      "text-[#4B4B4B] dark:text-[#DDDDDD]"
    ]
  end

  defp color_variant("transparent", "primary") do
    [
      "text-[#007F8C] dark:text-[#01B8CA]"
    ]
  end

  defp color_variant("transparent", "secondary") do
    [
      "text-[#266EF1] dark:text-[#6DAAFB]"
    ]
  end

  defp color_variant("transparent", "success") do
    [
      "text-[#0E8345] dark:text-[#06C167]"
    ]
  end

  defp color_variant("transparent", "warning") do
    [
      "text-[#CA8D01] dark:text-[#FDC034]"
    ]
  end

  defp color_variant("transparent", "danger") do
    [
      "text-[#DE1135] dark:text-[#FC7F79]"
    ]
  end

  defp color_variant("transparent", "info") do
    [
      "text-[#0B84BA] dark:text-[#3EB7ED]"
    ]
  end

  defp color_variant("transparent", "misc") do
    [
      "text-[#8750C5] dark:text-[#BA83F9]"
    ]
  end

  defp color_variant("transparent", "dawn") do
    [
      "text-[#A86438] dark:text-[#DB976B]"
    ]
  end

  defp color_variant("transparent", "silver") do
    [
      "text-[#868686] dark:text-[#A6A6A6]"
    ]
  end

  defp color_variant("gradient", "natural") do
    [
      "bg-gradient-to-br from-[#282828] to-[#727272] text-white",
      "dark:from-[#A6A6A6] dark:to-[#FFFFFF] dark:text-black"
    ]
  end

  defp color_variant("gradient", "primary") do
    [
      "bg-gradient-to-br from-[#016974] to-[#01B8CA] text-white",
      "dark:from-[#01B8CA] dark:to-[#B0E7EF] dark:text-black"
    ]
  end

  defp color_variant("gradient", "secondary") do
    [
      "bg-gradient-to-br from-[#175BCC] to-[#6DAAFB] text-white",
      "dark:from-[#6DAAFB] dark:to-[#CDDEFF] dark:text-black"
    ]
  end

  defp color_variant("gradient", "success") do
    [
      "bg-gradient-to-br from-[#166C3B] to-[#06C167] text-white",
      "dark:from-[#06C167] dark:to-[#B1EAC2] dark:text-black"
    ]
  end

  defp color_variant("gradient", "warning") do
    [
      "bg-gradient-to-br from-[#976A01] to-[#FDC034] text-white",
      "dark:from-[#FDC034] dark:to-[#FEDF99] dark:text-black"
    ]
  end

  defp color_variant("gradient", "danger") do
    [
      "bg-gradient-to-br from-[#BB032A] to-[#FC7F79] text-white",
      "dark:from-[#FC7F79] dark:to-[#FFD2CD] dark:text-black"
    ]
  end

  defp color_variant("gradient", "info") do
    [
      "bg-gradient-to-br from-[#08638C] to-[#3EB7ED] text-white",
      "dark:from-[#3EB7ED] dark:to-[#9FDBF6] dark:text-black"
    ]
  end

  defp color_variant("gradient", "misc") do
    [
      "bg-gradient-to-br from-[#653C94] to-[#BA83F9] text-white",
      "dark:from-[#BA83F9] dark:to-[#DDC1FC] dark:text-black"
    ]
  end

  defp color_variant("gradient", "dawn") do
    [
      "bg-gradient-to-br from-[#7E4B2A] to-[#DB976B] text-white",
      "dark:from-[#DB976B] dark:to-[#EDCBB5] dark:text-black"
    ]
  end

  defp color_variant("gradient", "silver") do
    [
      "bg-gradient-to-br from-[#5E5E5E] to-[#A6A6A6] text-white",
      "dark:from-[#868686] dark:to-[#BBBBBB] dark:text-black"
    ]
  end

  defp color_variant(params, _) when is_binary(params), do: params
end
