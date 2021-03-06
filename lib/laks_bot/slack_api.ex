defmodule LaksBot.SlackApi do

  require Logger

  def get_info do
    HTTPoison.get(get_url) |>
      handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code} = response}) when status_code in 200..399 do
    Poison.decode!(response.body)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    Logger.debug "Error when retrieving Slack API: #{inspect body}, code: #{status_code}"
    {:error, nil}
  end

  defp get_url do
    token = Application.get_env(:laks_bot, :slack_api_key)
    "https://slack.com/api/rtm.start?token=#{URI.encode token}"
  end

end
