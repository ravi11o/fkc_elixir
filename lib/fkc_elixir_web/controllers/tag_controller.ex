defmodule FkcElixirWeb.TagController do
  use FkcElixirWeb, :controller

  alias FkcElixir.Forum
  alias FkcElixir.Forum.Tag

  def index(conn, _params) do
    tags = Forum.list_tags()
    render(conn, "index.html", tags: tags)
  end

  def new(conn, _params) do
    changeset = Forum.change_tag(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    case Forum.create_tag(tag_params) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.tag_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   tag = Forum.get_tag!(id)
  #   render(conn, "show.html", tag: tag)
  # end

  # def edit(conn, %{"id" => id}) do
  #   tag = Forum.get_tag!(id)
  #   changeset = Forum.change_tag(tag)
  #   render(conn, "edit.html", tag: tag, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "tag" => tag_params}) do
  #   tag = Forum.get_tag!(id)

  #   case Forum.update_tag(tag, tag_params) do
  #     {:ok, tag} ->
  #       conn
  #       |> put_flash(:info, "Tag updated successfully.")
  #       |> redirect(to: Routes.tag_path(conn, :show, tag))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", tag: tag, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    tag = Forum.get_tag!(id)
    {:ok, _tag} = Forum.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end
end
