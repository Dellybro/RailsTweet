if Rails.env.production?
	config.paperclip_defaults = {
	  		:storage => :s3,
  			:s3_credentials => {
    		:bucket => 'twitterclone-assets-users'
  		}
	}
end