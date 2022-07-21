defmodule FkcElixirWeb.IndexLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)
    {:ok, assign(socket, questions: list_questions(), count: count_questions())}
  end

  defp list_questions do
    Forum.list_questions()
  end

  defp count_questions do
    Forum.count_questions()
  end
end
