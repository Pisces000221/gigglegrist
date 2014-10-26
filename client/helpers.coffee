Template.header.events
  'click #a_logout': -> Meteor.logout()

Meteor.subscribe 'masks'

Session.setDefault 'logged_in', false
Tracker.autorun -> Session.set 'logged_in', Meteor.userId()?

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
Template.registerHelper 'current_maskname', -> GM.masks.findOne(Meteor.user().profile.last_mask).name
Template.registerHelper 'logged_in', -> Session.get 'logged_in'

Template.registerHelper 'my_masks', -> GM.masks.find _id: $in: Meteor.user().profile.masks
Template.registerHelper 'cur_avatar', -> if @avatar is '' then 'http://www.gravatar.com/avatar/' + md5(@_id) + '?d=identicon' else @avatar
Template.registerHelper 'has_avatar', -> @avatar isnt ''
Template.registerHelper 'has_avatar_edit', -> @avatar isnt '' and not Session.get 'removed_avatar'  # 在马甲编辑页面中使用
Template.registerHelper 'hash_colour', -> '#' + window.hex_colour @colour
Template.registerHelper 'rgba_colour', (alpha) -> "rgba(#{@colour.r}, #{@colour.g}, #{@colour.b}, #{alpha})"

######## 全局方法 ########
# http://stackoverflow.com/q/3032721
# 加载Javascript和样式表的方法
window.load_script = (script_url) ->
  script_tag = document.createElement 'script'
  script_tag.type = 'text/javascript'
  script_tag.src = script_url
  document.head.appendChild script_tag

window.hex2 = (n) ->
  s = n.toString(16)
  if s.length is 1 then '0' + s else s

window.hex_colour = (c) -> window.hex2(c.r) + window.hex2(c.g) + window.hex2(c.b)

window.rgba_colour = (c, alpha) -> "rgba(#{c.r}, #{c.g}, #{c.b}, #{alpha})"

window.avatar = (mask) -> if mask.avatar is '' then 'http://www.gravatar.com/avatar/' + md5(mask._id) + '?d=identicon' else mask.avatar
