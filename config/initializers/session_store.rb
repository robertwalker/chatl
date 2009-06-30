# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_chatl_session',
  :secret      => 'f0504f350a3d4b11b31489df7a3d06e86f897d2e53a24e2fb600fa54cf4e8c30410553e8d12af02ea334ed441514d5be6c70140c17cbf81c8a67b8f818300e8c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
