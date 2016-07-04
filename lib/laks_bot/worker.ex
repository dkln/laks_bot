
defmodule LaksBot.Worker do

  alias LaksBot.Messaging
  require Logger

  @doc """
  Starts worker process.
  """
  def start_link do
    connection = LaksBot.Connection.open!
    Task.start_link(fn -> work(connection) end)
  end

  def work(connection) do
    {:ok, message} = Messaging.receive(connection)
    {:ok, connection} = handle_message(message, connection)

    work(connection)
  end

  @doc """
  Handles private message to the bot
  """
  defp handle_message(%{"type" => "message", "text" => text, "user" => user_id} = message, connection) do
    case Regex.run(~r/^<@([0-9A-Z]+)>: (.*)/, text, capture: :all_but_first) do
      [user_id, private_message] ->
        cond do
          user_id == connection.bot_id ->
            Logger.info "Private message to me #{private_message} #{inspect message}"
            LaksBot.Messaging.send!(connection, "O hi :wave:", message["channel"])

          true ->
            Logger.info "Private message to somebody #{private_message}"

        end

      nil ->
        Logger.info "Message to everybody"

    end

    {:ok, connection}
  end

  defp handle_message(%{}, connection) do
    {:ok, connection}
  end

end
