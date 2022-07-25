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

    sort_by = (params["sort_by"] || "inserted_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    questions =
      Forum.list_questions(
        paginate: paginate_options,
        sort: sort_options
      )

    socket =
      assign(socket,
        options: Map.merge(paginate_options, sort_options),
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

  defp sort_link(socket, text, sort_by, options) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        ),
      class: "test-Q3 dark"
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc
end
