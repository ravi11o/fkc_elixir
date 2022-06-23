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
end
