defmodule FkcElixirWeb.QuestionLive.Details do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show: false)}
  end

  @impl true
  def handle_params(%{"slug" => _slug}, _, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      #  |> assign(:question, Forum.get_question_and_update_view!(id))
      #  |> assign(:question_tags, Forum.get_question_tags(id))}
    }
  end

  defp page_title(:details), do: "Question Details"
end
