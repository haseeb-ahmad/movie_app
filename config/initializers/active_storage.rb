# config/initializers/active_storage.rb
ActiveSupport.on_load(:active_storage_current) do
  ActiveStorage::Current.url_options = Rails.application.routes.default_url_options
end
