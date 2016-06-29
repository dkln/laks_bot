defmodule LaksBot.Messaging do

  require Logger

  @doc """
  Receives Slack messages. This call is blocking.
  """
  @spec receive!(LaksBot.Connection) :: no_return
  def receive!(connection = %LaksBot.Connection{socket: socket}) do
    case socket |> Socket.Web.recv! do
      {:text, text} ->
        Poison.decode!(text)

      {:binary, binary} ->
        Logger.warn("Don't know how to handle binaries")

      {:ping, ping} ->
        Socket.Web.pong!(socket, ping)
        receive!(connection)

      {:pong, pong} ->
        Logger.warn("Pong")

      {type, _, _} ->
        Logger.warn("Unknown socket message received: #{inspect type}")

    end
  end

  @doc """
  Sends Slack messages.
  """
  @spec send!(LaksBot.Connection, String.t, String.t) :: LaksBot.Connection
  def send!(connection = %LaksBot.Connection{socket: socket, last_message_id: message_id}, text, channel_id) do
    json = Poison.encode!(%{id: message_id, type: "message", text: text, channel: channel_id}) |>
      IO.iodata_to_binary

    IO.puts json

    :ok = Socket.Web.send!(socket, {:text, json})

    %LaksBot.Connection{connection | last_message_id: message_id + 1}
  end

  @doc """
  Joins a given channel. This only works for non-bot users.
  """
  @spec join_channel(String.t) :: no_return
  def join_channel(channel_name) do
    HTTPoison.post!("https://slack.com/api/channels.join", {:form, [{:token, Application.get_env(:laks_bot, :api_key)}, {:name, channel_name}]})
  end

  @doc """
  Finds the channel id of the bot (by looking up _self)
  """
  def find_bot_channel_id(%LaksBot.Connection{metadata: %{self: self}}) do
  end

  @doc """
  Finds the ID of a given channel
  """
  def find_channel_id(%LaksBot.Connection{metadata: %{channels: channels}}, channel_name) do
    Enum.find(channels, fn(x) -> x["name"] == channel_name end)
  end

end
