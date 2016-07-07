defmodule LaksBot.Actions do
  require Logger

  alias LaksBot.GiphyApi
  alias LaksBot.Messaging

  # regex, defined action and a list of arguments (that matches index in regex)
  @private_actions [
    {~r/^(gif me |picture me )(.*)$/i, :search_gif, [1]},
    {~r/^show karma$/,                 :show_karma, nil}
  ]

  @public_actions [
    {~r/([\w]+)\+\+$/, :increase_karma, [0]},
    {~r/([\w]+)\-\-$/, :decrease_karma, [0]}
  ]

  def get_reaction_to_text(:private, text, %LaksBot.State{} = state) do
    get_reaction_to_text(@private_actions, text, state)
  end

  def get_reaction_to_text(:public, text, %LaksBot.State{} = state) do
    get_reaction_to_text(@public_actions, text, state)
  end

  def get_reaction_to_text(actions, text, %LaksBot.State{} = state) do
    for {regex, method, arguments} <- actions do
      matches = Regex.run(regex, text, capture: :all_but_first)

      if matches != nil do
        func_arguments = find_action_arguments(matches, arguments)
        action = perform_action(method, func_arguments)

        {action, state}
      end
    end
  end

  defp find_action_arguments(_matches, nil) do
    []
  end

  defp find_action_arguments(matches, arguments) do
    tuple_matches = List.to_tuple(matches)

    func_arguments = Enum.map(arguments, fn(x) ->
      elem(tuple_matches, x)
    end)
  end

  defp perform_action(:search_gif, [ gif ]) do
    {:ok, %{"images" => %{"original_still" => %{"url" => url}}}} = GiphyApi.search(String.trim(gif))
    {:send_message, url}
  end

  defp perform_action(action, _) do
    Logger.info "Action #{action} not defined. Please define it with :perform_action"
    :nothing
  end
end
