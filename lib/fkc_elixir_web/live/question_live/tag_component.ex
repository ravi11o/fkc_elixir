defmodule FkcElixirWeb.QuestionLive.TagComponent do
  use FkcElixirWeb, :live_component

  alias FkcElixir.Forum

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(tag: "")
      |> assign(tags: Forum.list_tags())
      |> assign(suggest_tags: [])
    }
  end

  def handle_event("suggest", %{"tag" => tag}, socket) do
    suggested = suggest(socket.assigns.tags, tag)
    socket = assign(socket, tag: tag, suggest_tags: suggested)

    {:noreply, socket}
  end

  def handle_event("add_tag", %{"tag" => tag}, socket) do
    tag = String.to_integer(tag)

    case Forum.add_question_tag(socket.assigns.question, tag) do
      {:ok, question} ->
        socket = assign(socket, question: question, tag: "")
        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket}
    end

    {:noreply, socket}
  end

  defp suggest(_tags, ""), do: []

  defp suggest(tags, prefix) do
    Enum.filter(tags, &has_prefix?(&1, prefix))
  end

  defp has_prefix?(tag, prefix) do
    String.starts_with?(String.downcase(tag.name), String.downcase(prefix))
  end
end
