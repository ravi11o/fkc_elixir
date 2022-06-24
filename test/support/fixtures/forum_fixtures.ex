defmodule FkcElixir.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FkcElixir.Forum` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        views: 42
      })
      |> FkcElixir.Forum.create_question()

    question
  end

  @doc """
  Generate a unique tag name.
  """
  def unique_tag_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: unique_tag_name()
      })
      |> FkcElixir.Forum.create_tag()

    tag
  end
end
