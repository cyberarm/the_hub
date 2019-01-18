.flash
  - if env.flash[:error]?
    p.error=env.flash[:error]

  - if env.flash[:alert]?
    p.alert=env.flash[:alert]

  - if env.flash[:notice]?
    p.notice=env.flash[:notice]
