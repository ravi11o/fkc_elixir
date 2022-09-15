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
end
