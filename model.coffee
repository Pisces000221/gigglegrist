# 在客户端和服务器端都会加载
# CoffeeScript定义全局变量不方便，所以使用Javascript

`
GM = {};
Rooms = new Meteor.Collection('rooms');
Masks = new Meteor.Collection('masks');
`
GM.rooms = Rooms
GM.masks = Masks

GM.register = (email) ->
  Meteor.call 'register', email

GM.enroll = (args...) ->
  Meteor.call 'enroll', args...

GM.create_mask = (args...) ->
  Meteor.call 'create_mask', args...

GM.create_room = (args...) ->
  Meteor.call 'create_room', args...
