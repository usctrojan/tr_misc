require "#{TrizleClient.models_dir}/business"
class Business
  has_many :business_ribbons
  has_many :ribbons, :through => :business_ribbons
  has_many :fans, :dependent => :destroy




  has_many :quest_rewards, :dependent => :destroy

  def next_quest
    return Quest.first if quest_rewards.empty?

    # find the last quest rewarded
    furthest_quest = quest_rewards.find(:last, :order => "quest_id")

    # find any quest before the furthest one that's incomplete
    # (e.g. business might complete the 4th quest, but hasn't completed the 3rd one)
    quests_completed_before_furthest_quest_rewarded = Quest.find(:all, :conditions => ["id < ?", furthest_quest.quest_id]).reject{|q|quest_rewards.collect(&:quest_id).include?(q.id)}
    if quests_completed_before_furthest_quest_rewarded.empty?
      return Quest.where(["id > ?", furthest_quest.quest_id]).first
    else
      return quests_completed_before_furthest_quest_rewarded.first
    end
  rescue
    return Quest.last
  end

  def next_quest_surprise_offer_ends_at
    if quest_rewards.empty?
      created_at + next_quest.hours_given_to_complete_for_surprise.hours
    else
      quest_rewards.order("created_at").last.created_at + next_quest.hours_given_to_complete_for_surprise.hours
    end
  end

  def seconds_until_next_quest_surprise_offer_ends
    t = next_quest_surprise_offer_ends_at - Time.now
    t = 0 if Time.now > next_quest_surprise_offer_ends_at
    return t.to_i
  end

  def next_quest_surprise_offer_available?
    seconds_until_next_quest_surprise_offer_ends > 0
  end

end