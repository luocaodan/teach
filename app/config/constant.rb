module Constant
  GitLabHost = 'http://gitlab.ce'.freeze
  TeachHost = 'http://127.0.0.1:8080'.freeze
  WebhookUrl = "#{TeachHost}/webhook".freeze

  # admin token
  PRIVATE_TOKEN = 'tQZ3aDCXkzxRy6V23CPk'.freeze

  # oauth application config
  APP_ID = 'd0272f9ec2c0f63e3922b1d4484aad5b01189a718b1bb1a4bc0af91c6f9d262f'.freeze
  APP_SECRET = '527da804ad9b6b2cb82afa63a2524fce1cc3a29ec95980e244787f941c6876ca'.freeze
  ACCESS_TOKEN_URL = "#{GitLabHost}/oauth/token".freeze
  REDIRECT_URI = "#{TeachHost}/oauth/callback".freeze

end