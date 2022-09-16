defmodule FkcElixirWeb.AnswerFormComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.{Forum, Repo, Forum.Answer}

  def update(assigns, socket) do
    changeset =
      cond do
        assigns.answer -> Forum.change_answer(assigns.answer)
        true -> Forum.change_answer(%Answer{})
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    current_user = socket.assigns.current_user
    question_id = socket.assigns.question.id

    changeset =
      Forum.change_answer(
        %Answer{user_id: current_user.id, question_id: question_id},
        answer_params
      )

    case Repo.insert(changeset) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer created Successfully")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("update", %{"answer" => answer_params}, socket) do
    changeset = Forum.change_answer(socket.assigns.answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        send_update(FkcElixirWeb.AnswerComponent, id: answer.id, answer: answer)

        {:noreply,
         socket
         |> put_flash(:info, "Answer Updated Successfully")
         |> push_redirect(to: "/question/#{socket.assigns.question.slug}")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end

    {:noreply, socket}
  end
end
