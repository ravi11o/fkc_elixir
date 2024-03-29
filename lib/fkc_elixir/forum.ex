defmodule FkcElixir.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias FkcElixir.Repo

  alias FkcElixir.Forum.{
    Question,
    Answer,
    Comment,
    AComment,
    Tag,
    QuestionVote,
    AnswerVote,
    CommentVote,
    ACommentVote
  }

  def subscribe do
    Phoenix.PubSub.subscribe(FkcElixir.PubSub, "questions")
  end

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    # Repo.all(Question)

    Question
    |> order_by(desc: :inserted_at)
    |> preload([:tags, :user, :answers, :question_votes])
    |> Repo.all()
  end

  def list_questions(criteria) when is_list(criteria) do
    query = from(s in Question)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from(q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page
        )

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from(q in query, order_by: [{^sort_order, ^sort_by}])
    end)
    |> order_by(desc: :inserted_at)
    |> preload([:tags, :user, :answers, :question_votes])
    |> Repo.all()
  end

  def count_questions do
    Question
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id) do
    # Repo.get!(Question, id)
    Question
    |> preload(:tags)
    |> Repo.get!(id)
  end

  def get_question_and_update_view(id) do
    question = Repo.get!(Question, id)

    question
    |> Question.changeset(%{views: question.views + 1})
    |> Repo.update()
    |> broadcast(:question_updated)
  end

  def get_question_by_slug!(slug) do
    question = Repo.get_by!(Question, slug: slug)

    question
    |> Question.changeset(%{views: question.views + 1})
    |> Repo.update!()
    |> Repo.preload(comments: [:user, :comment_votes])
    |> Repo.preload([:user, :tags, :answers, :question_votes])
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, question_tags(attrs))
    |> Repo.insert()

    # |> broadcast(:question_created)
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, question_tags(attrs))
    |> Repo.update()

    # |> broadcast(:question_updated)
  end

  # def broadcast({:ok, resource}, :question_comment) do
  #   Phoenix.PubSub.broadcast(FkcElixir.PubSub, "questions", :question_comment)

  #   {:ok, resource}
  # end

  def broadcast({:ok, resource}, event) do
    Phoenix.PubSub.broadcast(FkcElixir.PubSub, "questions", {event, resource})

    {:ok, resource}
  end

  def broadcast({:error, _changeset} = error, _event), do: error

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
    # Phoenix.PubSub.broadcast(FkcElixir.PubSub, "questions", :question_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  # tags requests

  def list_tags do
    Tag
    # |> select([t], %{id: t.id, name: t.name})
    |> Repo.all()
  end

  def get_tag!(id) do
    Repo.get!(Tag, id)
  end

  def get_tag_by_name!(name) do
    Repo.get_by!(Tag, name: name)
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    # Repo.all(Comment)

    Comment
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:question_comment)
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  ## Answers Queries
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:answer_created)
  end

  def list_answers(id) do
    Answer
    |> where([a], a.question_id == ^id)
    |> preload(a_comments: [:user, :a_comment_votes])
    |> preload([:user, :answer_votes])
    |> Repo.all()
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end

  ## Answer Comment Queries

  def create_answer_comment(attrs \\ %{}) do
    %AComment{}
    |> AComment.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:answer_comment)
  end

  def update_answer_comment(%AComment{} = a_comment, attrs) do
    a_comment
    |> AComment.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer_comment(%AComment{} = a_comment) do
    Repo.delete(a_comment)
  end

  def change_answer_comment(%AComment{} = a_comment, attrs \\ %{}) do
    AComment.changeset(a_comment, attrs)
  end

  ## Tags parsing

  defp parse_tags(nil), do: []

  defp parse_tags(tags) do
    # Repo.insert_all requires the inserted_at and updated_at to be filled out
    # and they should have time truncated to the second that is why we need this
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    for tag <- String.split(tags, ","),
        tag = tag |> String.trim() |> String.downcase(),
        tag != "",
        do: %{name: tag, inserted_at: now, updated_at: now}
  end

  defp question_tags(attrs) do
    # => [%{name: "phone", inserted_at: ..},  ...]
    tags = parse_tags(attrs["tag"])

    # do an upsert ensuring that all the input tags are present
    Repo.insert_all(Tag, tags, on_conflict: :nothing)

    tag_names = for t <- tags, do: t.name
    # find all the input tags
    Repo.all(from(t in Tag, where: t.name in ^tag_names))
  end

  ### Votimg section
  def upvote_question(qid, uid) do
    %QuestionVote{vote: :up}
    |> QuestionVote.changeset(%{question_id: qid, user_id: uid})
    |> Repo.insert()
  end

  def downvote_question(qid, uid) do
    %QuestionVote{vote: :down}
    |> QuestionVote.changeset(%{question_id: qid, user_id: uid})
    |> Repo.insert()
  end

  def upvote_answer(aid, uid) do
    %AnswerVote{vote: :up}
    |> AnswerVote.changeset(%{answer_id: aid, user_id: uid})
    |> Repo.insert()
  end

  def downvote_answer(aid, uid) do
    %AnswerVote{vote: :down}
    |> AnswerVote.changeset(%{answer_id: aid, user_id: uid})
    |> Repo.insert()
  end

  def upvote_comment(cid, uid, topic) do
    case topic do
      :question ->
        %CommentVote{vote: :up}
        |> CommentVote.changeset(%{comment_id: cid, user_id: uid})
        |> Repo.insert()

      :answer ->
        %ACommentVote{vote: :up}
        |> ACommentVote.changeset(%{a_comment_id: cid, user_id: uid})
        |> Repo.insert()
    end
  end

  def downvote_comment(cid, uid, topic) do
    case topic do
      :question ->
        %CommentVote{vote: :down}
        |> CommentVote.changeset(%{comment_id: cid, user_id: uid})
        |> Repo.insert()

      :answer ->
        %ACommentVote{vote: :down}
        |> ACommentVote.changeset(%{a_comment_id: cid, user_id: uid})
        |> Repo.insert()
    end
  end

  def get_votes(id, topic) do
    case topic do
      :question ->
        QuestionVote
        |> where([q], q.question_id == ^id)
        |> Repo.all()

      :answer ->
        AnswerVote
        |> where([a], a.answer_id == ^id)
        |> Repo.all()

      :comment ->
        CommentVote
        |> where([c], c.comment_id == ^id)
        |> Repo.all()

      :answer_comment ->
        ACommentVote
        |> where([ac], ac.a_comment_id == ^id)
        |> Repo.all()
    end
  end

  def votes(id, topic) do
    get_votes(id, topic)
  end

  def upvote(id, topic) do
    votes(id, topic)
    |> Enum.filter(&(&1.vote == :up))
  end

  def downvote(id, topic) do
    votes(id, topic)
    |> Enum.filter(&(&1.vote == :down))
  end

  def count_comment_votes(id, topic) do
    case topic do
      :question -> count_votes(id, :comment)
      :answer -> count_votes(id, :answer_comment)
    end
  end

  def count_votes(id, topic) do
    upvote_count = length(upvote(id, topic))
    downvote_count = length(downvote(id, topic))

    upvote_count - downvote_count
  end

  #### Text Search Query

  defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"

  defp search(query, search_term) do
    where(
      query,
      fragment(
        "to_tsvector('english', title || ' ' || description) @@
        to_tsquery(?)",
        ^prefix_search(search_term)
      )
    )
  end

  def search_results(term) do
    Question
    |> search(term)
    |> preload([:tags, :user, :answers, :question_votes])
    |> Repo.all()
  end

  ### Get questions by tags
  def search_tag_results(name) do
    tag =
      get_tag_by_name!(name)
      |> Repo.preload(questions: [:user, :tags, :answers, :question_votes])

    tag.questions
  end
end
