module Courseoutlines
	class Application < Rails::Application
		config.before_initialize do
			AD_CONFIG = YAML.load_file("#{Rails.root}/config/ad.yml")
		end
	end
end
