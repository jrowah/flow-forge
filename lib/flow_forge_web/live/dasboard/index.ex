defmodule FlowForgeWeb.Dashboard.Index do
  use FlowForgeWeb, :live_view

  # Require authenticated user
  on_mount {FlowForgeWeb.LiveUserAuth, :live_user_required}

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:show_logout_modal, false)}
  end

  def handle_event("logout", _params, socket) do
    {:noreply, redirect(socket, to: ~p"/sign-out")}
  end
end
