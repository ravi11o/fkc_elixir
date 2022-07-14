defmodule FkcElixirWeb.CommentController do
  use FkcElixirWeb, :controller

  alias FkcElixir.Forum
  alias FkcElixir.Forum.Comment

  import FkcElixirWeb.UserAuth

  plug :require_authenticated_user when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    comments = Forum.list_comments()
    IO.inspect(comments)
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Forum.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    comment_params = Map.put(comment_params, "user_id", conn.assigns.current_user.id)

    case Forum.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Forum.get_comment!(id)
    IO.inspect(comment)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Forum.get_comment!(id)
    changeset = Forum.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Forum.get_comment!(id)

    case Forum.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Forum.get_comment!(id)
    {:ok, _comment} = Forum.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.comment_path(conn, :index))
  end
end
