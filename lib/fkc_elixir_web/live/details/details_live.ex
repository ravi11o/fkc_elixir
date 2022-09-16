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
      |> assign(question: question, answers: answers)
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
    {:noreply, update(socket, :comment_form, fn val -> !val end)}
  end

  def handle_event("save_ques_comment", %{"comment" => comment_params}, socket) do
    question = socket.assigns.question
    current_user = socket.assigns.current_user
    new_params = %{comment_params | "question_id" => question.id, "user_id" => current_user.id}

    case Forum.create_comment(new_params) do
      {:ok, _comment} ->
        socket = assign(socket, :comment_form, false)

        {:noreply, push_redirect(socket, to: "/question/#{socket.assigns.question.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not add comment")
         |> push_redirect(to: socket.assigns.current_path)}
    end

    {:noreply, socket}
  end

  def handle_event("delete_question", _params, socket) do
    IO.inspect("delete started")

    case Forum.delete_question(socket.assigns.question) do
      {:ok, _} ->
        IO.inspect("deleted")
        {:noreply, push_redirect(socket, to: "/")}

      {:error, reason} ->
        IO.inspect(reason)
        {:noreply, socket}
    end
  end
end
