defmodule FkcElixirWeb.QuestionLive.New do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum
  alias FkcElixir.Forum.Question

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    socket = assign(socket, current_path: URI.parse(url).path)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, Forum.get_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, %Question{tags: []})
  end
end
