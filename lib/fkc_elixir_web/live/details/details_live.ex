defmodule FkcElixirWeb.DetailsLive do
  use FkcElixirWeb, :live_view

  # alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    IO.inspect(slug)

    {
      :noreply,
      socket
      |> assign(:page_title, "Details | #{slug}")
      #  |> assign(:question, Forum.get_question_and_update_view!(id))
      #  |> assign(:question_tags, Forum.get_question_tags(id))}
    }
  end
end
