class TalkVisit < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user
end
