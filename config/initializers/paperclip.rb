if Rails.env.production?
	config.paperclip_defaults = {
	  		:storage => :s3,
  			:s3_credentials => {
    		:bucket => 'twitterclone-assets-users'
			:aws_access_key_id		=> ENV['aws_access_key_id'],
			:aws_secret_access_key 	=> ENV['aws_secret_access_key']
  		}
	}
end