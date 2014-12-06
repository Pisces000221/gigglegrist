Template.header.events
  'click #a_logout': -> Meteor.logout()

Meteor.subscribe 'grists'
Meteor.subscribe 'avatars'

Session.setDefault 'logged_in', false
Tracker.autorun -> Session.set 'logged_in', Meteor.userId()?

Template.registerHelper 'go_homepage', -> Router.go '/'

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
Template.registerHelper 'current_gristname', -> GM.grists.findOne(Meteor.user().profile.last_grist).name
Template.registerHelper 'logged_in', -> Session.get 'logged_in'

Template.registerHelper 'my_level', -> GM.level Meteor.user().profile.chattypt

Template.registerHelper 'my_grists', -> GM.grists.find _id: $in: Meteor.user().profile.grists
Template.registerHelper 'avatar', (x) -> window.avatar x
Template.registerHelper 'cur_avatar', -> window.avatar this
Template.registerHelper 'has_avatar', -> @avatar isnt ''
Template.registerHelper 'has_avatar_edit', -> @avatar isnt '' and not Session.get 'removed_avatar'  # 在Grist编辑页面中使用
Template.registerHelper 'hash_colour', -> '#' + window.hex_colour @colour
Template.registerHelper 'rgba_colour', (alpha) -> "rgba(#{@colour.r}, #{@colour.g}, #{@colour.b}, #{alpha})"

Template.registerHelper 'auto_fit_bg', (c) -> if window.is_light_colour c then '#000' else '#fff'

Template.registerHelper 'readable_time', (timestamp) -> moment(timestamp).locale('zh-cn').calendar()

######## 全局方法 ########
# http://stackoverflow.com/q/3032721
# 加载Javascript和样式表的方法
window.load_script = (script_url) ->
  script_tag = document.createElement 'script'
  script_tag.type = 'text/javascript'
  script_tag.src = script_url
  document.head.appendChild script_tag

# 把页面滚动到底部
# http://stackoverflow.com/q/11715646/
# 加一个54是由于body的margin-bottom是54（见global.css），懒得用API获取了～
window.scroll_to_bottom = -> window.scrollTo 0, document.body.scrollHeight + 54

window.hex2 = (n) ->
  s = n.toString(16)
  if s.length is 1 then '0' + s else s

# 自行Google一下“判断RGB颜色亮度”之类的东西吧，这个是直接从jscolor里抠来的
window.is_light_colour = (c) ->
  0.213 * c.r + 0.715 * c.g + 0.072 * c.b > 0.5 * 255

window.hex_colour = (c) -> window.hex2(c.r) + window.hex2(c.g) + window.hex2(c.b)

window.rgba_colour = (c, alpha) -> "rgba(#{c.r}, #{c.g}, #{c.b}, #{alpha})"

window.avatar = (grist) -> if grist.avatar is '' then 'http://www.gravatar.com/avatar/' + md5(grist._id) + '?d=identicon' else window.avatar_img grist.avatar

window.avatar_img = (avatar_id) -> GM.avatars.findOne(avatar_id).img

######## header ########
Session.setDefault 'header_login_in_progress', false
Session.setDefault 'header_login_message', ''

Template.header.helpers
  'in_progress': -> Session.get 'header_login_in_progress'
  'message': -> Session.get 'header_login_message'

Template.header.events
  'click #btn_header_login': ->
    Session.set 'header_login_in_progress', true
    Session.set 'header_login_message', ''
    email = document.getElementById('txt_header_email').value
    password = document.getElementById('txt_header_password').value
    Meteor.loginWithPassword email, password, (err) ->
      Session.set 'header_login_message', err.toString() if err?
      Session.set 'header_login_in_progress', false
