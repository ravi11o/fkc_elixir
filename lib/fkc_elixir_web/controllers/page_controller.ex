defmodule FkcElixirWeb.PageController do
  use FkcElixirWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
