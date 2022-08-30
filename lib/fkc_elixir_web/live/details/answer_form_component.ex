defmodule FkcElixirWeb.AnswerFormComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.{Forum, Repo, Forum.Answer}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: Forum.change_answer(%Answer{}))
     |> assign(
       answer: %Answer{
         question_id: assigns.question.id,
         user_id: assigns.current_user && assigns.current_user.id
       }
     )}
  end

  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset =
      socket.assigns.answer
      |> Forum.change_answer(answer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    IO.inspect(socket)
    changeset = Forum.change_answer(socket.assigns.answer, answer_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer created Successfully")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
