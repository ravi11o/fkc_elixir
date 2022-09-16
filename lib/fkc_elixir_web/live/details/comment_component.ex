defmodule FkcElixirWeb.CommentComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.Forum

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    case assigns.for do
      :question ->
        changeset = Forum.change_comment(comment)

        {:ok,
         socket
         |> assign(assigns)
         |> assign(:changeset, changeset)}

      :answer ->
        changeset = Forum.change_answer_comment(comment)

        {:ok,
         socket
         |> assign(assigns)
         |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_event("comment_upvote", %{"cid" => cid, "for" => for}, socket) do
    if(socket.assigns.current_user) do
      case Forum.upvote_comment(cid, socket.assigns.current_user.id, String.to_atom(for)) do
        {:ok, _} ->
          {:noreply,
           socket
           |> put_flash(:info, "#{for} comment Upvoted")
           |> push_redirect(to: "/question/#{socket.assigns.slug}")}

        {:error, _} ->
          {:noreply,
           socket
           |> put_flash(:info, "Already Voted")
           |> push_redirect(to: "/question/#{socket.assigns.slug}")}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("comment_downvote", %{"cid" => cid, "for" => for}, socket) do
    if(socket.assigns.current_user) do
      case Forum.downvote_comment(cid, socket.assigns.current_user.id, String.to_atom(for)) do
        {:ok, _} ->
          {:noreply,
           socket
           |> put_flash(:info, "#{for} comment Downvoted")
           |> push_redirect(to: "/question/#{socket.assigns.slug}")}

        {:error, _} ->
          {:noreply,
           socket
           |> put_flash(:info, "Already Voted")
           |> push_redirect(to: "/question/#{socket.assigns.slug}")}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("delete_question_comment", _, socket) do
    case Forum.delete_comment(socket.assigns.comment) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment Deleted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Something went wrong")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}
    end
  end

  def handle_event("delete_answer_comment", _, socket) do
    case Forum.delete_answer_comment(socket.assigns.comment) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment Deleted")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Something went wrong")
         |> push_redirect(to: "/question/#{socket.assigns.slug}")}
    end
  end
end
