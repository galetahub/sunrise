class HistoryTracker
  include Mongoid::History::Tracker

  def user
    @user ||= modifier
  end

  def username
    user.try(:name)
  end

  def user_type
    "User"
  end

  def user_id
    user.try(:id)
  end

  def auditable_type
    "Post"
  end

  def auditable_id
    1
  end

  def remote_address
    nil
  end
end