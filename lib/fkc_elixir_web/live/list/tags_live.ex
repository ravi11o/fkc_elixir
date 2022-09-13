defmodule FkcElixirWeb.TagsLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  def mount(_, session, socket) do
    socket = assign_current_user(socket, session)
    tags = Forum.list_tags()
    {:ok, assign(socket, tags: tags)}
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, current_path: URI.parse(url).path)}
  end
end
