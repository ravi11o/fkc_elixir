defmodule FkcElixirWeb.RegisterLive do
  use FkcElixirWeb, :live_view

  alias FkcElixir.Accounts
  alias FkcElixir.Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      allow_upload(
        socket,
        :image,
        accept: ~w(.png .jpg .jpeg),
        max_file_size: 5_000_000
      )

    {:ok, assign(socket, changeset: changeset, trigger_submit: false)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    [photo | _] =
      consume_uploaded_entries(socket, :image, fn meta, entry ->
        dest = Path.join("priv/static/uploads", filename(entry))
        File.cp!(meta.path, dest)
        Routes.static_path(socket, "/uploads/#{filename(entry)}")
      end)

    # {completed, []} = uploaded_entries(socket, :image)

    # [photo | _] =
    #   for entry <- completed do
    #     Routes.static_path(socket, "/uploads/#{filename(entry)}")
    #   end

    changeset = registration_changeset(%{params | "image" => photo})

    {:noreply, assign(socket, changeset: changeset, trigger_submit: changeset.valid?)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = registration_changeset(params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp registration_changeset(params) do
    %User{}
    |> Accounts.change_user_registration(params)
    |> Map.put(:action, :insert)
  end

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end
end
