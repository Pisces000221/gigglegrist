# 在客户端和服务器端都会加载
# CoffeeScript定义全局变量不方便，所以使用Javascript

`
GM = {};
Greenhouses = new Meteor.Collection('ghouses');
Grists = new Meteor.Collection('grists');
Messages = new Meteor.Collection('messages');
Avatars = new Meteor.Collection('avatars');
`
GM.ghouses = Greenhouses
GM.grists = Grists
GM.messages = Messages
GM.avatars = Avatars

GM.register = (email) ->
  Meteor.call 'register', email

GM.enroll = (args...) ->
  Meteor.call 'enroll', args...

GM.create_grist = (args...) ->
  Meteor.call 'create_grist', args...

GM.modify_grist = (args...) ->
  Meteor.call 'modify_grist', args...

GM.create_ghouse = (args...) ->
  Meteor.call 'create_ghouse', args...

GM.modify_ghouse = (args...) ->
  Meteor.call 'modify_ghouse', args...

GM.speak = (args...) ->
  Meteor.call 'speak', args...

GM.use_grist = (args...) ->
  Meteor.call 'use_grist', args...

GM.level_up_pt = (lv) -> 10 + lv * 5

GM.level_total_pt = (lv) ->
  r = 0
  r += GM.level_up_pt lv-- while lv > 0
  r

GM.level = (pt) ->
  lv = 0
  up_pt = 0
  while up_pt <= pt
    lv++
    up_pt += GM.level_up_pt lv
  lv
`GM_level = GM.level`
