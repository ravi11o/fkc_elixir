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
      Forum.upvote_comment(cid, socket.assigns.current_user.id, String.to_atom(for))
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("comment_downvote", %{"cid" => cid, "for" => for}, socket) do
    if(socket.assigns.current_user) do
      Forum.downvote_comment(cid, socket.assigns.current_user.id, String.to_atom(for))
    end

    {:noreply, socket}
  end
end
