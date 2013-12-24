CarrierWave.configure do |config|
  config.azure_credentials = {
    storage_account_name: 'mediasvc12kb9xf06tbbz',
    storage_access_key:   'IYnAyt8bnGfPLMWVxGz+mcWas12CT04bTLdj/BJ7vEgemiHvL3vxUj4cRU/PoPegsU6z0qgGSKV0bGih+NhXAg=='
  }
  config.azure_container = 'khcpl'
  # config.azure_host = 'YOUR CDN HOST' # optional
end