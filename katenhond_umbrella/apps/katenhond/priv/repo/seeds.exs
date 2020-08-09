{:ok, _cs} =
    Katenhond.UserContext.create_seed(%{"password" => "t", "role" => "User", "username" => "user"})

{:ok, _cs} =
    Katenhond.UserContext.create_seed(%{"password" => "t", "role" => "Admin", "username" => "admin"})