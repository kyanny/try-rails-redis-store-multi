# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_redis-store-multi_session'
Rails.application.config.session_store :redis_store, servers: 'redis://127.0.0.1:6379'
# Rails.application.config.session_store :redis_store, servers: [{host: '127.0.0.1', port: '6379'}, {host: '127.0.0.1', port: '7777'}]
