if Rails.env.production?
	CarrierWave.configure do |config|
		config.fog_credentials = {
			#configuation for AmazingS3
			:provider				=> 'AWS',
			:aws_access_key_id		=> ENV['AKIAIZM5HIQBF47MRRYA'],
			:aws_secret_access_key 	=> ENV['ACCESSSECRET']
		}
		config.fog_directory		= ENV['S3_BUCKET']
	end
end