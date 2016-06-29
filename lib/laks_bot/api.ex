defmodule LaksBot.Api do

  require Logger

  def get_info do
    HTTPoison.get(get_url) |>
      handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code} = response}) when status_code in 200..399 do
    Poison.decode!(response.body)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    Logger.debug "response: #{inspect body}, code: #{status_code}"
    {:error, nil}
  end

  defp get_url do
    token = Application.get_env(:laks_bot, :api_key)
    "https://slack.com/api/rtm.start?token=#{URI.encode token}"
  end

end
