Locomotive.configure do |config|
  config.multi_sites do |multi_sites|
    multi_sites.domain = 'example.com'
    multi_sites.reserved_subdomains = %w(www admin locomotive email blog webmail mail support help site sites)
  end

  config.enable_logs = true
end
