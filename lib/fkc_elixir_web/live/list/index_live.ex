defmodule FkcElixirWeb.IndexLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"term" => term}, _url, socket) do
    questions = Forum.search_results(term)
    {:noreply, assign(socket, questions: questions, count: length(questions))}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "2")

    paginate_options = %{page: page, per_page: per_page}
    questions = Forum.list_questions(paginate: paginate_options)

    socket =
      assign(socket,
        options: paginate_options,
        questions: questions,
        count: count_questions()
      )

    {:noreply, socket}
  end

  defp count_questions do
    Forum.count_questions()
  end

  @impl true
  def handle_event("question-serach", %{"search" => term}, socket) do
    questions = Forum.search_results(term)
    {:noreply, assign(socket, questions: questions, count: length(questions))}
  end
end
