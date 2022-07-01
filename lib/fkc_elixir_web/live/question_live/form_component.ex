defmodule FkcElixirWeb.QuestionLive.FormComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.Forum

  @impl true
  def update(%{question: question} = assigns, socket) do
    changeset = Forum.change_question(question)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(tag: "")
     |> assign(tags: Forum.list_tags())
     |> assign(suggest_tags: [])
     |> assign(selected_tags: [])
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    changeset =
      socket.assigns.question
      |> Forum.change_question(question_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_question(socket, socket.assigns.action, question_params)
  end

  def handle_event("add_tag", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  # def handle_event("add_tag", _, socket) do
  #   {:noreply, socket}
  # end

  defp save_question(socket, :edit, question_params) do
    case Forum.update_question(socket.assigns.question, question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_question(socket, :new, question_params) do
    case Forum.create_question(question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
