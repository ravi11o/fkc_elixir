defmodule FkcElixirWeb.DetailsLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    question = Forum.get_question_by_slug!(slug)
    answers = Forum.list_answers(question.id)

    {
      :noreply,
      socket
      |> assign(:page_title, "Details | #{slug}")
      |> assign(question: question, answers: answers)
    }
  end
end
