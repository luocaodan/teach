module DevelopmentConstant
  GitLabHost = 'http://gitlab.ce'.freeze
  TeachHost = 'http://127.0.0.1:3000'.freeze
  WebhookUrl = "#{TeachHost}/webhook".freeze

  # admin token
  # PRIVATE_TOKEN = 'tQZ3aDCXkzxRy6V23CPk'.freeze
  PRIVATE_TOKEN = 'oMP6bjQhpw1nG4BYTm3t'.freeze

  # oauth application config
  APP_ID = '2a35559a8ad74c3756b9cc63cdacf4c6efb4a9ae304f6776b317455918505fbc'.freeze
  APP_SECRET = '89b6517b55f703a83e573fd92000607095c3f5cad2fabbc84d8619655b02230f'.freeze
  REDIRECT_URI = "#{TeachHost}/oauth/callback".freeze
  ACCESS_TOKEN_URL = "#{GitLabHost}/oauth/token".freeze
end