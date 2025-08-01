defmodule FlowForgeWeb.Components.Breadcrumb do
  @moduledoc """
  Provides a flexible and customizable `FlowForgeWeb.Components.Breadcrumb` component for displaying
  breadcrumb navigation in your Phoenix LiveView applications.

  ## Features

  - **Customizable Appearance**: Choose from various color themes and sizes to match your design needs.
  - **Icon and Separator Support**: Easily add icons and separators between breadcrumb items
  for improved navigation.
  - **Flexible Structure**: Use slots to define breadcrumb items, each with optional icons,
  links, and custom separators.
  - **Global Attributes**: Utilize global attributes to customize and extend the component's
  behavior and appearance.
  """
  use Phoenix.Component
  import FlowForgeWeb.Components.Icon, only: [icon: 1]

  @doc """
  The `breadcrumb` component is used to display a navigational path with customizable
  attributes such as `color`, `size`, and `separator`.

  It supports defining individual items with optional icons and links, allowing for flexible
  breadcrumb trails.

  ## Examples

  ```elixir
  <.breadcrumb>
    <:item icon="hero-academic-cap" link="/">Route1</:item>
    <:item icon="hero-beaker" link="/">Route2</:item>
    <:item icon="hero-computer-desktop" link="/">Route3</:item>
    <:item>Route3</:item>
  </.breadcrumb>

  <.breadcrumb color="info" size="medium">
    <:item icon="hero-academic-cap">Route1</:item>
    <:item icon="hero-beaker">Route2</:item>
    <:item icon="hero-computer-desktop">Route3</:item>
    <:item>Route3</:item>
  </.breadcrumb>

  <.breadcrumb color="secondary" size="small">
    <:item link="/">Route1</:item>
    <:item link="/">Route2</:item>
    <:item link="/">Route3</:item>
    <:item link="/">Route3</:item>
  </.breadcrumb>
  ```
  """
  @doc type: :component
  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"
  attr :items_wrapper_class, :string, default: nil, doc: "Custom CSS class for additional styling"

  attr :id, :string,
    default: nil,
    doc: "A unique identifier is used to manage state and interaction"

  attr :separator_icon, :string,
    default: "hero-chevron-right",
    doc: "Determines a separator for items of an element"

  attr :separator_icon_class, :string,
    default: "rtl:rotate-180",
    doc: "Custom CSS class for additional styling"

  attr :separator_text, :string,
    default: nil,
    doc: "Determines a separator for items of an element"

  attr :separator_text_class, :string,
    default: nil,
    doc: "Determines a separator for items of an element"

  attr :color, :string, default: "base", doc: "Determines color theme"

  attr :size, :string,
    default: "small",
    doc:
      "Determines the overall size of the elements, including padding, font size, and other items"

  slot :item, required: false, doc: "Specifies item slot of a breadcrumb" do
    attr :icon, :string, doc: "Icon displayed alongside of an item"
    attr :link, :string, doc: "Renders a navigation, patch link or normal link"
    attr :title, :string, doc: "Renders a navigation, patch link or normal link"
    attr :class, :string, doc: "Custom CSS class for additional styling"
    attr :icon_class, :string, doc: "Custom CSS class for additional styling"
    attr :link_class, :string, doc: "Custom CSS class for additional styling"
  end

  attr :rest, :global,
    doc:
      "Global attributes can define defaults which are merged with attributes provided by the caller"

  slot :inner_block, required: false, doc: "Inner block that renders HEEx content"

  def breadcrumb(assigns) do
    ~H"""
    <nav class={@class} id={@id} {@rest}>
      <ol class={[default_classes(), color_class(@color), size_class(@size), @items_wrapper_class]}>
        <li
          :for={{item, index} <- Enum.with_index(@item, 1)}
          class={["flex items-center", item[:class]]}
        >
          <.icon
            :if={!is_nil(item[:icon])}
            name={item[:icon]}
            class={["breadcrumb-icon", item[:icon_class]]}
          />
          <.link
            :if={!is_nil(item[:link])}
            navigate={item[:link]}
            title={item[:tile]}
            class={item[:link_class]}
          >
            {render_slot(item)}
          </.link>

          <div :if={is_nil(item[:link])}>{render_slot(item)}</div>

          <.icon
            :if={@separator_icon && index < Enum.count(@item)}
            name={@separator_icon}
            class={["separator-icon", @separator_icon_class]}
          />
          <span
            :if={@separator_text && !@separator_icon && index < Enum.count(@item)}
            class={["separator-text", @separator_text_class]}
          >
            {@separator_text}
          </span>
        </li>
        {render_slot(@inner_block)}
      </ol>
    </nav>
    """
  end

  defp color_class("base") do
    [
      "text-[#09090b] hover:[&>li_a]:text-[#1b1b1f]",
      "dark:text-[#FAFAFA] dark:hover:[&>li_a]:text-[#ededed]"
    ]
  end

  defp color_class("white") do
    [
      "text-white hover:[&>li_a]:text-[#DDDDDD]"
    ]
  end

  defp color_class("dark") do
    [
      "text-[#282828] hover:[&>li_a]:text-[#727272]"
    ]
  end

  defp color_class("natural") do
    [
      "text-[#4B4B4B] hover:[&>li_a]:text-[#282828]",
      "dark:text-[#DDDDDD] dark:hover:[&>li_a]:text-[#E8E8E8]"
    ]
  end

  defp color_class("primary") do
    [
      "text-[#007F8C] hover:[&>li_a]:text-[#016974]",
      "dark:text-[#01B8CA] dark:hover:[&>li_a]:text-[#77D5E3]"
    ]
  end

  defp color_class("secondary") do
    [
      "text-[#266EF1] hover:[&>li_a]:text-[#175BCC]",
      "dark:text-[#6DAAFB] dark:hover:[&>li_a]:text-[#A9C9FF]"
    ]
  end

  defp color_class("success") do
    [
      "text-[#0E8345] hover:[&>li_a]:text-[#166C3B]",
      "dark:text-[#06C167] dark:hover:[&>li_a]:text-[#7FD99A]"
    ]
  end

  defp color_class("warning") do
    [
      "text-[#CA8D01] hover:[&>li_a]:text-[#CA8D01]",
      "dark:text-[#FDC034] dark:hover:[&>li_a]:text-[#FDD067]"
    ]
  end

  defp color_class("danger") do
    [
      "text-[#DE1135] hover:[&>li_a]:text-[#BB032A]",
      "dark:text-[#FC7F79] dark:hover:[&>li_a]:text-[#FFB2AB]"
    ]
  end

  defp color_class("info") do
    [
      "text-[#0B84BA] hover:[&>li_a]:text-[#08638C]",
      "dark:text-[#3EB7ED] dark:hover:[&>li_a]:text-[#6EC9F2]"
    ]
  end

  defp color_class("misc") do
    [
      "text-[#8750C5] hover:[&>li_a]:text-[#653C94]",
      "dark:text-[#BA83F9] dark:hover:[&>li_a]:text-[#CBA2FA]"
    ]
  end

  defp color_class("dawn") do
    [
      "text-[#A86438] hover:[&>li_a]:text-[#7E4B2A]",
      "dark:text-[#DB976B] dark:hover:[&>li_a]:text-[#E4B190]"
    ]
  end

  defp color_class("silver") do
    [
      "text-[#868686] hover:[&>li_a]:text-[#727272]",
      "dark:text-[#A6A6A6] dark:hover:[&>li_a]:text-[#BBBBBB]"
    ]
  end

  defp color_class(params) when is_binary(params), do: params

  defp size_class("extra_small") do
    "text-xs gap-1.5 [&>li]:gap-1.5 [&>li>.separator-icon]:size-3 [&>li>.breadcrumb-icon]:size-4"
  end

  defp size_class("small") do
    "text-sm gap-2 [&>li]:gap-2 [&>li>.separator-icon]:size-3.5 [&>li>.breadcrumb-icon]:size-5"
  end

  defp size_class("medium") do
    "text-base gap-2.5 [&>li]:gap-2.5 [&>li>.separator-icon]:size-4 [&>li>.breadcrumb-icon]:size-6"
  end

  defp size_class("large") do
    "text-lg gap-3 [&>li]:gap-3 [&>li>.separator-icon]:size-5 [&>li>.breadcrumb-icon]:size-7"
  end

  defp size_class("extra_large") do
    "text-xl gap-3.5 [&>li]:gap-3.5 [&>li>.separator-icon]:size-6 [&>li>.breadcrumb-icon]:size-8"
  end

  defp size_class(params) when is_binary(params), do: params

  defp default_classes do
    [
      "flex items-center transition-all ease-in-ou duration-100 group"
    ]
  end
end
