defmodule FkcElixirWeb.AnswerComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.Forum

  @impl true
  def update(%{answer: answer} = assigns, socket) do
    changeset = Forum.change_answer(answer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(edit: false)
     |> assign(comment_form: false)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("answer_upvote", %{"aid" => aid, "uid" => uid}, socket) do
    case Forum.upvote_answer(aid, uid) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer Upvoted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Already Upvoted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}
    end
  end

  def handle_event("answer_downvote", %{"aid" => aid, "uid" => uid}, socket) do
    case Forum.downvote_answer(aid, uid) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer Downvoted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Already Voted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}
    end
  end

  def handle_event("answer_upvote", _, socket) do
    {:noreply, socket}
  end

  def handle_event("answer_downvote", _, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_answer", _, socket) do
    {:noreply, update(socket, :edit, &(!&1))}
  end

  def handle_event("delete_answer", _, socket) do
    case Forum.delete_answer(socket.assigns.answer) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer Deleted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Something went wrong")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}
    end
  end

  def handle_event("answer_comment_form", _, socket) do
    {:noreply, update(socket, :comment_form, fn val -> !val end)}
  end

  def handle_event("save_answer_comment", %{"comment" => comment_params}, socket) do
    answer = socket.assigns.answer
    current_user = socket.assigns.current_user
    new_params = %{comment_params | "answer_id" => answer.id, "user_id" => current_user.id}

    case Forum.create_answer_comment(new_params) do
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
