# 在这里向客户端发布所有的数据库

Meteor.publish 'users', -> Meteor.users.find()
Meteor.publish 'rooms', -> GM.rooms.find()
Meteor.publish 'masks', -> GM.masks.find()
Meteor.publish 'messages', -> GM.messages.find()
Meteor.publish 'avatars', -> GM.avatars.find()
