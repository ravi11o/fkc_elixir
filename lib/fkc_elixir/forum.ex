defmodule FkcElixir.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias FkcElixir.Repo

  alias FkcElixir.Forum.{Question, Answer, Comment, AComment, Tag}

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
    |> preload([:tags, :user, :answers])
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
    |> Repo.preload(comments: [:user])
    |> Repo.preload([:user, :tags, :answers])
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
    |> broadcast(:question_created)
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, question_tags(attrs))
    |> Repo.update()
    |> broadcast(:question_updated)
  end

  def broadcast({:ok, question}, event) do
    Phoenix.PubSub.broadcast(FkcElixir.PubSub, "questions", {event, question})

    {:ok, question}
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
    Phoenix.PubSub.broadcast(FkcElixir.PubSub, "questions", :question_deleted)
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
  end

  def list_answers(id) do
    Answer
    |> where([a], a.question_id == ^id)
    |> preload(a_comments: [:user])
    |> preload([:user])
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
end
