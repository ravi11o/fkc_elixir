defmodule FkcElixirWeb.AnswerComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.Forum

  @impl true
  def update(%{answer: answer} = assigns, socket) do
    changeset = Forum.change_answer(answer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("answer_upvote", %{"aid" => aid, "uid" => uid}, socket) do
    Forum.upvote_answer(aid, uid)
    {:noreply, socket}
  end

  def handle_event("answer_downvote", %{"aid" => aid, "uid" => uid}, socket) do
    Forum.downvote_answer(aid, uid)
    {:noreply, socket}
  end
end
