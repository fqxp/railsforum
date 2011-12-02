class TalkVisit < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user
  
  def self.mark_visited(talk_id, user_id)
    talk_visit = self.find_by_talk_id_and_user_id(talk_id, user_id) || \
      TalkVisit.new(:talk_id => talk_id, :user_id => user_id)
    @last_visited = talk_visit.last_visited
    talk_visit.last_visited = DateTime.now.utc
    talk_visit.save
  end
end
