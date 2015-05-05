if Rails.env.production?
	Paperclip::Attachment.default_options[:url] = 'twitterclone-assets-users.amazonaws.com'
	Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'
end