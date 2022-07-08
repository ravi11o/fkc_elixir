defmodule FkcElixir.ForumTest do
  use FkcElixir.DataCase

  alias FkcElixir.Forum

  describe "questions" do
    alias FkcElixir.Forum.Question

    import FkcElixir.ForumFixtures

    @invalid_attrs %{description: nil, title: nil, views: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Forum.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Forum.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{description: "some description", title: "some title", views: 42}

      assert {:ok, %Question{} = question} = Forum.create_question(valid_attrs)
      assert question.description == "some description"
      assert question.title == "some title"
      assert question.views == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", views: 43}

      assert {:ok, %Question{} = question} = Forum.update_question(question, update_attrs)
      assert question.description == "some updated description"
      assert question.title == "some updated title"
      assert question.views == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_question(question, @invalid_attrs)
      assert question == Forum.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Forum.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Forum.change_question(question)
    end
  end

  describe "tags" do
    alias FkcElixir.Forum.Tag

    import FkcElixir.ForumFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Forum.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Forum.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Forum.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Forum.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_tag(tag, @invalid_attrs)
      assert tag == Forum.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Forum.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Forum.change_tag(tag)
    end
  end

  describe "comments" do
    alias FkcElixir.Forum.Comment

    import FkcElixir.ForumFixtures

    @invalid_attrs %{title: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Forum.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Forum.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Comment{} = comment} = Forum.create_comment(valid_attrs)
      assert comment.title == "some title"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Comment{} = comment} = Forum.update_comment(comment, update_attrs)
      assert comment.title == "some updated title"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_comment(comment, @invalid_attrs)
      assert comment == Forum.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Forum.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Forum.change_comment(comment)
    end
  end
end
