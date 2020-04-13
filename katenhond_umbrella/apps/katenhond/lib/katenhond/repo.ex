defmodule Katenhond.Repo do
  use Ecto.Repo,
    otp_app: :katenhond,
    adapter: Ecto.Adapters.MyXQL
end
