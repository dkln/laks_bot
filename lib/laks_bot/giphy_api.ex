defmodule LaksBot.GiphyApi do

  require Logger

  def search(terms) do
    HTTPoison.get(get_url(terms)) |>
      handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code} = response}) when status_code in 200..399 do
    {:ok, result} = Poison.decode(response.body)

    case result["data"] do
      [ first | _ ] -> {:ok, first}
      []            -> {:not_found}
    end
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    Logger.debug "Error when retrieving Giphy API: #{inspect body}, code: #{status_code}"
    {:error, nil}
  end

  defp get_url(terms) do
    token = System.get_env("GIPHY_API_KEY") || Application.get_env(:laks_bot, :giphy_api_key)
    "http://api.giphy.com/v1/gifs/search?q=#{URI.encode terms}&api_key=#{URI.encode token}&limit=1"
  end

end
