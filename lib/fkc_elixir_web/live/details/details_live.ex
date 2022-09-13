defmodule FkcElixirWeb.DetailsLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum
  # alias FkcElixir.Forum.Answer

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, url, socket) do
    question = Forum.get_question_by_slug!(slug)
    answers = Forum.list_answers(question.id)
    # answer_changeset = Forum.change_answer(%Answer{})

    {
      :noreply,
      socket
      |> assign(:page_title, "Details | #{slug}")
      |> assign(:current_path, URI.parse(url).path)
      |> assign(:comment_form, false)
      |> assign(question: question, answers: answers, comments: question.comments)
    }
  end

  @impl true
  def handle_event("question_upvote", %{"qid" => qid, "uid" => uid}, socket) do
    case Forum.upvote_question(qid, uid) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question Upvoted")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Already Voted")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}
    end
  end

  def handle_event("question_downvote", %{"qid" => qid, "uid" => uid}, socket) do
    case Forum.downvote_question(qid, uid) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question Downvoted")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Already Voted")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}
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

  def handle_event("ques_comment_form", _, socket) do
    {:noreply, assign(socket, :comment_form, !socket.assigns.comment_form)}
  end

  def handle_event("save_ques_comment", %{"comment" => comment_params}, socket) do
    question_id = socket.assigns.question.id
    current_user = socket.assigns.current_user
    new_params = %{comment_params | "question_id" => question_id, "user_id" => current_user.id}

    case Forum.create_comment(new_params) do
      {:ok, _comment} ->
        {:noreply, push_redirect(socket, to: "/question/#{socket.assigns.question.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not add comment")
         |> push_redirect(to: socket.assigns.current_path)}
    end

    {:noreply, socket}
  end
end
