defmodule StiltzkeyWeb.PageController do
  use StiltzkeyWeb, :controller

  def index(conn, _params) do
    {:ok, vsn} = :application.get_key(:stiltzkey, :vsn)
    contributors = Stiltzkey.contributors()
    |> parse_contributors()
    |> Enum.sort()
    |> Enum.join(", ")
    render conn, "index.html", vsn: vsn, contributors: contributors
  end

  defp parse_contributors(contributors) do
    for contributor <- contributors do
      "#{contributor[:name]} (#{contributor[:github]})"
    end
  end
end
