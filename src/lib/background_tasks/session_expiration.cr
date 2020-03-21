BackgroundTask.new(1.minute).run do |task|
  Model::Session.where(:updated_at, :lt, Time.utc - FriendlyConfig::EXPIRE_SESSION_AFTER).each do |session|
    session.destroy
  end
end