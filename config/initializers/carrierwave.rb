CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage           = :file
    config.enable_processing = false
  elsif Rails.env.development?
    config.storage           = :file
  elsif Rails.env.production?
    config.storage         = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     'AKIAIU7MAU7YCJFL2A5A',
      aws_secret_access_key: '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'
    }
    config.fog_directory  = "foodgenome-production"
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  end
end
