NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

UserID = Match.Where (x) ->
  check x, NonEmptyString
  Meteor.users.find(x).count() isnt 0

ColourRGB = Match.Where (x) ->
  check x.r, Number
  check x.g, Number
  check x.b, Number
  0 <= x.r <= 255 and 0 <= x.g <= 255 and 0 <= x.b <= 255

GM = {}

# http://stackoverflow.com/questions/5623838/
GM.hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex
  if result then {
      r: parseInt result[1], 16
      g: parseInt result[2], 16
      b: parseInt result[3], 16
  }
  else null

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
  'enrolled': (user_id) -> Meteor.users.findOne(user_id).profile?.enrolled
  'enroll': (user_id, options) ->
    check user_id, UserID
    if Meteor.users.findOne(user_id).profile?.enrolled
      throw new Meteor.Error 403, '坑爹啊！你已经注册过了有木有？！'
    options.avatar ?= ''
    check options,
      username: NonEmptyString
      # TODO: 使用HTTPS或者更安全的办法传输这个信息（HTTP下直接传输密码太吓人了）
      password: NonEmptyString
      avatar: String
    Accounts.setPassword user_id, options.password
    # 创建第一个马甲
    @userId = user_id
    mask_id = Meteor.call 'create_mask', options.username, options.avatar
    @userId = null
    Meteor.users.update user_id, $set: { 'profile.enrolled': true, 'profile.last_mask': mask_id }
  'create_mask': (name, avatar) ->
    if not @userId?
      throw new Meteor.Error 403, '搞笑！没登录怎么创建马甲！'
    if Masks.findOne(name: name)?
      throw new Meteor.Error 403, '真不敢相信……你要的名字居然已经被用掉了……'
    avatar ?= ''
    check avatar, String
    id = Random.id()
    Masks.insert
      _id: id
      name: name
      avatar: avatar
      colour: GM.hexToRgb Please.make_color()
      timestamp: (new Date).getTime()
    console.log "第#{Masks.find().count()}个马甲被创建"
    Meteor.users.update @userId, $addToSet: 'profile.masks': id
    return id
  'modify_mask': (id, name, colour, avatar) ->
    if not @userId?
      throw new Meteor.Error 403, '貌似没登录？？'
    if Meteor.user().profile.masks.indexOf(id) is -1
      throw new Meteor.Error 403, '喂喂，不要乱动别人的东西哈'
    if not name? or not colour? or not avatar?
      throw new Meteor.Error 403, '把参数给全好不……'
    check name, String
    check colour, ColourRGB
    # 参数avatar的含义
    # ''：保持不变
    # 'remove'：删除原有的头像
    # 其它字符串：更改头像
    check avatar, String
    modifier = $set: { name: name, colour: colour }
    if avatar is 'remove' then modifier.$set.avatar = ''
    else if avatar isnt '' then modifier.$set.avatar = avatar
    Masks.update id, modifier
  'use_mask': (id) ->
    if not @userId?
      throw new Meteor.Error 403, '如果我没看错的话，你没登录'
    if Meteor.user().profile.masks.indexOf(id) is -1
      throw new Meteor.Error 403, '喂喂，不要乱动别人的东西哈'
    Meteor.users.update @userId, $set: 'profile.last_mask': id
  'create_room': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '貌似你还没登录……'
    check options,
      title: NonEmptyString
      description: NonEmptyString
    options.id ?= Random.id()
    Rooms.insert
      _id: options.id
      title: options.title
      description: options.description
      creator: options.creator
      timestamp: (new Date).getTime()
  'speak': (room, message) ->
    if not @userId?
      throw new Meteor.Error 403, '你忘登录了！'
    check message, NonEmptyString
    if Rooms.find(room).count() is 0
      throw new Meteor.Error 403, '木有这个房间'
    id = (Messages.find().count() + 1).toString()
    Messages.insert
      _id: id
      room: room
      speaker: Meteor.user().profile.last_mask
      message: message
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
