class BusinessRibbon < ActiveRecord::Base
##  acts_as_audited
  belongs_to :business
  belongs_to :ribbon

  def name
    ribbon.name
  end

  after_create :after_create_tasks
  def after_create_tasks
    business.add_notification("You've achieved the ribbon #{name}.", "/", User.find_by_login("trizle"))
  end




##  ## REDIS - NEWS FEED
##  include RedisMethods
##  def push_to_followers
##    # this pushes the notification to all people who are following this entry (to their unique feeds)
##    push_to_followers_of(business.user)
##    push_to_followers_of(business)
##  end
##  ######################
end

