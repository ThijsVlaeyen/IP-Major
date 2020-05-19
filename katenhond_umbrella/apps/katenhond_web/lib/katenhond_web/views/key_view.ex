defmodule KatenhondWeb.KeyView do
    use KatenhondWeb, :view
    
    def render("key.json", %{key: key}) do
        %{"#{key.name}": key.value}
    end

end