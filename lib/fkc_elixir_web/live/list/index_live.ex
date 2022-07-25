defmodule FkcElixirWeb.IndexLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(questions: list_questions(), count: count_questions())
  end

  defp list_questions do
    Forum.list_questions()
  end

  defp count_questions do
    Forum.count_questions()
  end

  def handle_event("question-serach", %{"search" => term}, socket) do
  end
end
