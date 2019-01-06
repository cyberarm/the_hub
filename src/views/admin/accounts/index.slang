h1.title Accounts
.monitors
  - if accounts
    - accounts.each do |user|
      .monitor
        .monitor_label
          h2 =user.username.not_nil!
        .monitor_content
          p =Model::User.get_role_name(user.role.not_nil!)
          img style="border-radius: 5pt; width: 100pt" src="https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.not_nil!)}?size=100&default=robohash"
        br