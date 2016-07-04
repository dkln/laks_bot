
defmodule LaksBot.Worker do

  alias LaksBot.Messaging
  require Logger

  @doc """
  Starts worker process.
  """
  def start_link do
    connection = LaksBot.Connection.open!
    state = %LaksBot.State{}
    Task.start_link(fn -> work(connection, state) end)
  end

  def work(connection, state) do
    {:ok, message} = Messaging.receive(connection)
    {:ok, connection, state} = handle_message(message, connection, state)

    work(connection, state)
  end

  @doc """
  Handles private message to the bot
  """
  defp handle_message(%{"type" => "message", "text" => text, "user" => user_id} = message, connection, %LaksBot.State{} = state) do
    case Regex.run(~r/^<@([0-9A-Z]+)>: (.*)/, text, capture: :all_but_first) do
      [user_id, text] ->
        cond do
          user_id == connection.bot_id ->
            {reaction, state} = LaksBot.Actions.get_reaction_to_text(:private, text, state)

          true ->
            nil

        end

      nil ->
        {reaction, state} = LaksBot.Actions.get_reaction_to_text(:public, text, state)

    end

    {:ok, connection, state}
  end

  defp handle_message(%{}, connection, %LaksBot.State{} = state) do
    {:ok, connection, state}
  end

end
