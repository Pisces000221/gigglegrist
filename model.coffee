# 在客户端和服务器端都会加载
# CoffeeScript定义全局变量不方便，所以使用Javascript

`
GM = {};
Rooms = new Meteor.Collection('rooms');
Masks = new Meteor.Collection('masks');
Messages = new Meteor.Collection('messages');
`
GM.rooms = Rooms
GM.masks = Masks
GM.messages = Messages

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
