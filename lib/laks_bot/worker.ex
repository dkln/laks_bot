defmodule LaksBot.Worker do

  alias LaksBot.Messaging
  require Logger

  @doc """
  Starts worker process.
  """
  def work do
    connection = LaksBot.Connection.open!
    work(connection)
  end

  def work(connection) do
    {:ok, message} = Messaging.receive(connection)
    {:ok, connection} = handle_message(message, connection)

    work(connection)
  end

  defp handle_message(%{"type" => "message", "text" => text, "user" => user_id} = message, connection) do
    Logger.info "User says #{text} -> #{inspect message}"
    Messaging.find_bot_user_id(connection)

    {:ok, connection}
  end

  defp handle_message(%{}, connection) do
    {:ok, connection}
  end

end
