defmodule LaksBot.Actions do
  require Logger

  @private_actions [
    {~r/^(gif me |picture me )(.*)$/i, :search_gif, [1]},
    {~r/^show karma$/,                 :show_karma, nil}
  ]

  @public_actions [
    {~r/(.*)++$/, :increase_karma},
    {~r/(.*)--$/, :decrease_karma}
  ]

  def match(:private, text) do
    match(@private_actions, text)
  end

  def match(:public, text) do
    match(@public_actions, text)
  end

  def match(actions, text) do
    for {regex, method, arguments} <- actions do
      matches = Regex.run(regex, text, capture: :all_but_first)

      if matches != nil do
        func_arguments = find_action_arguments(matches, arguments)
        perform_action(method, func_arguments)
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
    Logger.info "searching gif"
  end

  defp perform_action(_action, _) do
    Logger.info "unknown action"
  end
end
