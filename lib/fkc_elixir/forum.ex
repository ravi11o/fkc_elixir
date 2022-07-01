defmodule FkcElixir.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias FkcElixir.Repo

  alias FkcElixir.Forum.Question
  alias FkcElixir.Forum.Tag

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
    |> Repo.all()
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
    Repo.get!(Question, id)
  end

  def get_question_and_update_view!(id) do
    question = Repo.get!(Question, id)

    question
    |> Question.changeset(%{views: question.views + 1})
    |> Repo.update!()
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
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def add_question_tag(%Question{} = question, tag) do
    question
    |> Question.changeset(%{tags: question.tags ++ [tag]})
    |> Repo.update()
  end

  def remove_question_tag(questionId, tag) do
    question = get_question!(questionId)
    tag = String.to_integer(tag)

    question
    |> Question.changeset(%{tags: question.tags -- [tag]})
    |> Repo.update!()
  end

  def get_question_tags(id) do
    question = get_question!(id)
    from(t in Tag, where: t.id in ^question.tags) |> Repo.all()
  end

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
end
