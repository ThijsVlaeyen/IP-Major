defmodule KatenhondWeb.AnimalView do
    use KatenhondWeb, :view

    alias KatenhondWeb.AnimalView

    # Functies voor te renderen van json
    def render("index.json", %{animals: animals}) do
        %{data: render_many(animals, AnimalView, "animal.json")}
      end
      
    """
    def render("show.json", %{animal: animal}) do
        %{data: render_one(animal, AnimalView, "animal.json")}
    end
    """
    def render("show.json", %{animal: animal}) do
        %{id: animal.id,
          name: animal.name,
          cat_or_dog: animal.cat_or_dog,
          born: animal.born}
    end
    
    def render("animal.json", %{animal: animal}) do
        %{id: animal.id, 
          name: animal.name}
    end

end