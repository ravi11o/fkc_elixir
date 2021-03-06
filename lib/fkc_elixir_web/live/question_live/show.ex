defmodule FkcElixirWeb.QuestionLive.Show do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Forum.subscribe()
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, question} = Forum.get_question_and_update_view(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:question, question)}
  end

  @impl true
  def handle_info({:question_updated, question}, socket) do
    {:noreply, assign(socket, question: question)}
  end

  defp page_title(:show), do: "Show Question"
  defp page_title(:edit), do: "Edit Question"
end
