use Mix.Config

config :laks_bot,
          slack_api_key: System.get_env("SLACK_API_KEY"),
          giphy_api_key: System.get_env("GIPHY_API_KEY")
