defmodule FkcElixirWeb.IndexLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Forum

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Forum.subscribe()
    socket = assign_current_user(socket, session)

    {:ok, assign(socket, active: "questions")}
  end

  @impl true
  def handle_params(%{"term" => term} = params, _url, socket) do
    [paginate, sort] = create_options(params)
    questions = Forum.search_results(term)

    {:noreply,
     assign(socket,
       questions: questions,
       options: Map.merge(paginate, sort),
       count: length(questions)
     )}
  end

  def handle_params(%{"tag" => tag} = params, _url, socket) do
    [paginate, sort] = create_options(params)
    questions = Forum.search_tag_results(tag)

    {:noreply,
     assign(socket,
       questions: questions,
       options: Map.merge(paginate, sort),
       count: length(questions)
     )}
  end

  def handle_params(params, _url, socket) do
    [paginate_options, sort_options] = create_options(params)

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

  @impl true
  def handle_event("question-serach", %{"search" => term}, socket) do
    questions = Forum.search_results(term)
    {:noreply, assign(socket, questions: questions, count: length(questions))}
  end

  def handle_event("unanswered", _, socket) do
    questions =
      list_questions()
      |> Enum.filter(&(length(&1.answers) == 0))

    {:noreply, assign(socket, questions: questions)}
  end

  def handle_event("active_class", %{"button" => button}, socket) do
    {:noreply, assign(socket, active: button)}
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

  defp list_questions do
    Forum.list_questions()
  end

  defp count_questions do
    Forum.count_questions()
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp create_options(params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "4")

    sort_by = (params["sort_by"] || "inserted_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    [paginate_options, sort_options]
  end
end
