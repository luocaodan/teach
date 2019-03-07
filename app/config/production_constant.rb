module ProductionConstant
  GitLabHost = 'http://10.2.28.170'.freeze
  TeachHost = 'http://10.2.28.170:3000'.freeze
  WebhookUrl = "#{TeachHost}/webhook".freeze

  # admin token
  # PRIVATE_TOKEN = 'tQZ3aDCXkzxRy6V23CPk'.freeze
  PRIVATE_TOKEN = 'R2GQVs298zRVyW4ZTzAe'.freeze

  # oauth application config
  APP_ID = '448f1a1cecb3312b4099d76b3b9f3ad65172ba51ded099a33f0a3e6e914f98db'.freeze
  APP_SECRET = 'e2aebc01e5fe3e713f5c9cbdbe87cdf85ed5883c3d7ebe345f127809e85d0858'.freeze
  REDIRECT_URI = "#{TeachHost}/oauth/callback".freeze
  ACCESS_TOKEN_URL = "#{GitLabHost}/oauth/token".freeze
end