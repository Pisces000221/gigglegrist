NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

Meteor.methods
  'create_room': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '貌似你还没登录……'
    check options,
      title: NonEmptyString
      description: NonEmptyString
    options.id ?= Random.id()
    GM.rooms.insert
      _id: options.id
      title: options.title
      description: options.description
      creator: options.creator
      timestamp: (new Date).getTime()

# 防止在Firefox内无法显示某些东东
# 不解释，欲知详情请见GitHub上Pisces000221/plotipot/server/methods.coffee
Meteor.startup ->
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
