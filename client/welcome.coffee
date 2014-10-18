Session.setDefault 'welcome_msg', ''

Template.welcome.helpers
  'message': -> Session.get 'welcome_msg'

Template.welcome.events
  'click #btn_register': ->
    GM.register document.getElementById('txt_email').value
    Session.set 'welcome_msg', '为了确认你的身份，我们已经给你发送了一封邮件。还愣着干嘛？快去看你的收件箱！'
