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
end
