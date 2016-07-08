defmodule LaksBot.ReactionPerform do

  alias LaksBot.Messaging
  alias LaksBot.Connection
  alias LaksBot.State
  alias LaksBot.GiphyApi

  require Logger

  def perform([:search_gif, gif], %Connection{} = connection, %State{} = state) do
    {:ok, channel_id} = Messaging.find_bot_channel_id(connection)

    case GiphyApi.search(String.trim(gif)) do
      {:ok, %{"images" => %{"original" => %{"url" => url}}}} ->
        connection = Messaging.send!(connection, url, channel_id)

      {:not_found} ->
        connection = Messaging.send!(connection, "I could not find _#{gif}_", channel_id)

    end

    {connection, state}
  end

  def perform([], %Connection{} = connection, %State{} = state) do
    {connection, state}
  end

end
