defmodule FkcElixirWeb.QuestionLive.Index do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum
  alias FkcElixir.Forum.Question

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)
    {:ok, assign(socket, :questions, list_questions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
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
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Forum.get_question!(id)
    {:ok, _} = Forum.delete_question(question)

    {:noreply, assign(socket, :questions, list_questions())}
  end

  @impl true
  def handle_info({:question_created, question}, socket) do
    socket =
      update(
        socket,
        :questions,
        fn questions -> [question | questions] end
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:question_updated, question}, socket) do
    socket =
      update(
        socket,
        :questions,
        fn questions -> [question | questions] end
      )

    {:noreply, socket}
  end

  def handle_info(:question_deleted, socket) do
    {:noreply, assign(socket, :questions, list_questions())}
  end

  defp list_questions do
    Forum.list_questions()
  end
end
