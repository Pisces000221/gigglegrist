# 在这里向客户端发布所有的数据库

Meteor.publish 'rooms', -> GM.rooms.find()
