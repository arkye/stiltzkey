defmodule StiltzkeyWeb.Helpers.Input.Decorator do

  alias Phoenix.HTML.Form

  def class_decorate(%Form{params: params, errors: errors}, field) do
    if Map.has_key?(params, Atom.to_string(field)) do
      case errors[field] do
        nil -> "stzk-c-content valid"
        _ -> "stzk-c-content invalid"
      end
    else
      "stzk-c-content"
    end
  end
end
