NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

UserID = Match.Where (x) ->
  check x, NonEmptyString
  Meteor.users.find(x).count() isnt 0

ValidMaskName = Match.Where (x) ->
  check x, NonEmptyString
  true

GM = {}

GM.enrollmentEmailContent = (user_id) ->
  Meteor.absoluteUrl "enroll/#{user_id}"

GM.sendEnrollmentEmail = (user_id) ->
  user = Meteor.users.findOne user_id
  Email.send
    from: '"Mangostana Team" <1786762946@qq.com>'
    to: user.emails[0].address
    subject: 'Hi，我看到你了～～'
    html: GM.enrollmentEmailContent user_id

Meteor.methods
  'remove_all_users': (password) -> Meteor.users.remove({}) if password is 'let\nMe $1nTAT\t'
  'register': (email) ->
    id = Accounts.createUser email: email
    GM.sendEnrollmentEmail id
  'enroll': (user_id, options) ->
    check user_id, UserID
    options.avatar ?= ''
    check options,
      username: ValidMaskName
      # TODO: 使用HTTPS或者更安全的办法传输这个信息（HTTP下直接传输密码太吓人了）
      password: NonEmptyString
      avatar: String
    Accounts.setPassword user_id, options.password
    Meteor.users.update user_id, $set: profile: avatar: options.avatar
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

Meteor.startup ->
  # 防止在Firefox内无法显示某些东东
  # 不解释，欲知详情请见GitHub上Pisces000221/plotipot/server/methods.coffee
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
  # 设置要发送的e-mail模板
  Accounts.emailTemplates.from = '"Mangostana Team" <1786762946@qq.com>'
  Accounts.emailTemplates.siteName = 'Mangostana'
