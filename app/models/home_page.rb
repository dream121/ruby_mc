class HomePage < ActiveRecord::Base
	has_many :images, as: :imageable, dependent: :destroy
end
