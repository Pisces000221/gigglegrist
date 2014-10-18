# 在客户端和服务器端都会加载
# CoffeeScript定义全局变量不方便，所以使用Javascript

`GM = {}`
GM.rooms = new Meteor.Collection 'rooms'
GM.masks = new Meteor.Collection 'masks'

GM.register = (email) ->
  Meteor.call 'register', email

GM.enroll = (args...) ->
  Meteor.call 'enroll', args...

GM.create_room = (args...) ->
  Meteor.call 'create_room', args...