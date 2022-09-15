# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
alias FkcElixir.Accounts

Accounts.register_user(%{
  email: "ravi.suraj110@gmail.com",
  username: "ravi11o",
  password: System.get_env("ADMIN_PASS"),
  is_admin: true
})

#
#     FkcElixir.Repo.insert!(%FkcElixir.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
