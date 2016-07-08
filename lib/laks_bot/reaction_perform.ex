defmodule LaksBot.ReactionPerform do

  alias LaksBot.Messaging
  alias LaksBot.Connection
  alias LaksBot.State
  alias LaksBot.GiphyApi

  require Logger

  def perform([:search_gif, gif], %Connection{} = connection, %State{} = state) do
    case GiphyApi.search(String.trim(gif)) do
      {:ok, %{"images" => %{"original" => %{"url" => url}}}} ->
        connection = send_message(connection, url)

      {:not_found} ->
        connection = send_message(connection, "I could not find _#{gif}_")

    end

    {connection, state}
  end

  def perform([:increase_karma, subject], %Connection{} = connection, %State{} = state) do
    karma = (state.karma[subject] || 0) + 1
    state = put_in(state.karma[subject], karma)

    connection = send_message(connection, "Score! :muscle: Karma for *#{subject}* now *#{state.karma[subject]}*")

    {connection, state}
  end

  def perform([:decrease_karma, subject], %Connection{} = connection, %State{} = state) do
    karma = (state.karma[subject] || 0) - 1
    state = put_in(state.karma[subject], karma)

    connection = send_message(connection, "Darn :boom: Karma for *#{subject}* now *#{state.karma[subject]}*")

    {connection, state}
  end

  def perform([], %Connection{} = connection, %State{} = state) do
    {connection, state}
  end

  defp send_message(%Connection{} = connection, text) do
    {:ok, channel_id} = Messaging.find_bot_channel_id(connection)
    Messaging.send!(connection, text, channel_id)
  end

end
