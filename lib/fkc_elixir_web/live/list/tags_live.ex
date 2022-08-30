defmodule FkcElixirWeb.TagsLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  def mount(_, _, socket) do
    tags = Forum.list_tags()
    {:ok, assign(socket, tags: tags)}
  end
end
