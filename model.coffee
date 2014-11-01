# 在客户端和服务器端都会加载
# CoffeeScript定义全局变量不方便，所以使用Javascript

`
GM = {};
Rooms = new Meteor.Collection('rooms');
Masks = new Meteor.Collection('masks');
Messages = new Meteor.Collection('messages');
Avatars = new Meteor.Collection('avatars');
`
GM.rooms = Rooms
GM.masks = Masks
GM.messages = Messages
GM.avatars = Avatars

GM.register = (email) ->
  Meteor.call 'register', email

GM.enroll = (args...) ->
  Meteor.call 'enroll', args...

GM.create_mask = (args...) ->
  Meteor.call 'create_mask', args...

GM.modify_mask = (args...) ->
  Meteor.call 'modify_mask', args...

GM.create_room = (args...) ->
  Meteor.call 'create_room', args...

GM.speak = (args...) ->
  Meteor.call 'speak', args...

GM.use_mask = (args...) ->
  Meteor.call 'use_mask', args...

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
