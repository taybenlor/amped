Amped::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  # config.cache_store = :mem_cache_store
  config.serve_static_assets = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
  end  
end