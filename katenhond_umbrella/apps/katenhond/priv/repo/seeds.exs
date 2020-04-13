{:ok, _cs} =
    Katenhond.UserContext.create_user(%{"password" => "t", "role" => "User", "username" => "user"})

{:ok, _cs} =
    Katenhond.UserContext.create_user(%{"password" => "t", "role" => "Admin", "username" => "admin"})