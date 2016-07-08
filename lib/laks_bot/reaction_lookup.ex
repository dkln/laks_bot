defmodule LaksBot.ReactionLookup do
  require Logger

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

  def find(:private, text) do
    find(@private_actions, text)
  end

  def find(:public, text) do
    find(@public_actions, text)
  end

  def find(actions, text) do
    case actions
           |> find_matching_actions(text)
           |> Enum.reject(fn(x) -> x == nil end) do

      [ action | _ ] -> action
      _              -> []
    end
  end

  defp find_matching_actions(actions, text) do
    Enum.map(actions, fn({regex, action, arguments}) ->
      case Regex.run(regex, text, capture: :all_but_first) do
        nil     -> nil
        matches ->
          func_arguments = find_action_arguments(matches, arguments)
          Enum.concat([action], func_arguments)
      end
    end)
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

end
