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

  @impl true
  def handle_event("question_upvote", %{"qid" => qid, "uid" => uid}, socket) do
    case Forum.upvote_question(qid, uid) do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _} ->
        put_flash(socket, :info, "Already Voted")
        {:noreply, socket}
    end
  end

  def handle_event("question_downvote", %{"qid" => qid, "uid" => uid}, socket) do
    case Forum.downvote_question(qid, uid) do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _} ->
        put_flash(socket, :info, "Already Voted")
        {:noreply, socket}
    end
  end

  def handle_event("question_upvote", _, socket) do
    {:noreply, socket}
  end

  def handle_event("question_downvote", _, socket) do
    {:noreply, socket}
  end

  def handle_event("question-serach", %{"search" => term}, socket) do
    {:noreply, push_redirect(socket, to: "/?term=#{term}")}
  end
end
