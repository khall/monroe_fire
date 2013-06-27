# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
token = 'developmentdevelopmentdevelopmentdevelopmentdevelopment'
raise "Secret token needs to be set to something secret" if Rails.env.production? && (token == 'development' || token.length < 30)
Fire::Application.config.secret_token = token
Fire::Application.config.secret_key_base = token
