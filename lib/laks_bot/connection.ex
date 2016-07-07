defmodule LaksBot.Connection do

  require Logger

  defstruct socket: nil, last_message_id: 1, metadata: nil, bot_id: nil, state: nil

  @doc """
  Opens a Slack connection.
  """
  @spec open! :: LaksBot.Connection | no_return
  def open! do
    body = LaksBot.SlackApi.get_info
    socket = Socket.connect!(body["url"])

    %LaksBot.Connection{socket: socket, metadata: body, bot_id: body["self"]["id"]}
  end

  @doc """
  Closes Slack connection.
  """
  @spec close(LaksBot.Connection) :: :ok | {:error, String.t}
  def close(_connection = %LaksBot.Connection{socket: socket}) do
    case Socket.Web.close(socket) do
      :ok ->
        :ok

      {:error, error} ->
        Logger.warn "Failed to close connection. Error: #{error}"
        {:error, error}
    end
  end

end
