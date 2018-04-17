defmodule StiltzkeyWeb.Helpers.Locale.Plug do
  import Plug.Conn

  @locales Gettext.known_locales(StiltzkeyWeb.Gettext)

  def init(default_locale), do: default_locale

  def call(conn, _opts) do
    case locale_from_params(conn)
      || locale_from_cookies(conn)
      || locale_from_header(conn) do
      nil -> conn
      locale ->
        Gettext.put_locale(StiltzkeyWeb.Gettext, locale)
        persist_locale(conn, locale)
    end
  end

  defp locale_from_params(conn) do
    conn.params["locale"] |> validate_locale
  end

  defp locale_from_cookies(conn) do
    conn.cookies["locale"] |> validate_locale
  end

  defp validate_locale(locale) when locale in @locales, do: locale
  defp validate_locale(_locale), do: nil

  defp persist_locale(conn, new_locale) do
    if conn.cookies["locale"] != new_locale do
      put_resp_cookie conn, "locale", new_locale, max_age: 86400
    else
      conn
    end
  end

  defp locale_from_header(conn) do
    conn
    |> SetLocale.Headers.extract_accept_language
    |> Enum.find(nil, fn(accepted_locale) ->
      Enum.member?(@locales, accepted_locale)
    end)
  end
end
