defmodule FlowForgeWeb.PageController do
  use FlowForgeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
