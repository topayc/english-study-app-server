class AdvertiseCpdLog < ActiveRecord::Base

	belongs_to :user
	belongs_to :cpd_advertisement

end
