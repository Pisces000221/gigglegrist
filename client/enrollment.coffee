Meteor.subscribe 'users'
Session.setDefault 'enroll_msg', ''

Template.enrollment.helpers
  'email': -> Meteor.users.findOne(this.trim()).emails[0].address
  'message': -> Session.get 'enroll_msg'

Template.enrollment.events
  'click #btn_submit': ->
    file = document.getElementById('file_avatar').files[0]
    reader = new FileReader()
    current_id = this.trim()

    reader.onloadend = ->
      # 文件加载完成（或者根本没有加载），准备出发
      GM.enroll current_id, {
        username: document.getElementById('txt_username').value
        password: document.getElementById('txt_password').value
        avatar: reader.result
      }, (err, result) ->
        if err then alert "出了点问题……\n#{err.toString()}"
        else Meteor.loginWithPassword id: current_id, document.getElementById('txt_password').value

    if file
      reader.readAsDataURL file
    else
      reader.onloadend()
