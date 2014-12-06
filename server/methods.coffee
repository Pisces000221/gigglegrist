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

# 使用如下方法获得物种信息：
# 访问 http://species.wikimedia.org/w/api.php?action=query&format=json&continue=&list=allpages&apprefix=属&aplimit=500
# 打开Web Console，运行：
#  a = 把页面上的所有东东粘贴到这里
#  b = []
#  a.query.allpages.forEach(function(e) { b.push(e.title) })
#  b.toSource()
GM.initial_species = ["Eleocharis acicularis", "Eleocharis acutangula", "Eleocharis afflata", "Eleocharis angustispicula", "Eleocharis atropurpurea", "Eleocharis baldwinii", "Eleocharis brittonii", "Eleocharis congesta", "Eleocharis cryptica", "Eleocharis densicaespitosa", "Eleocharis dulcis", "Eleocharis elegans", "Eleocharis filiculmis", "Eleocharis geniculata", "Eleocharis glauco-virens", "Eleocharis hatschbachii", "Eleocharis kuroguwai", "Eleocharis loefgreniana", "Eleocharis macrostachya", "Eleocharis montana", "Eleocharis montevidensis", "Eleocharis nitida", "Eleocharis nodulosa", "Eleocharis obtusa", "Eleocharis palustris", "Eleocharis parishii", "Eleocharis parvula", "Eleocharis pellucida", "Eleocharis quadrangulata", "Eleocharis radicans", "Eleocharis ramboana", "Eleocharis rostellata", "Eleocharis sellowiana", "Eleocharis tenuis", "Eleocharis tortilis", "Eleocharis urceolatoides", "Eleocharis wolfii", "Garcinia afzelii", "Garcinia amboinensis", "Garcinia aristata", "Garcinia atroviridis", "Garcinia bancana", "Garcinia benthamii", "Garcinia binucao", "Garcinia brasiliensis", "Garcinia buchananii", "Garcinia cambogia", "Garcinia celebica", "Garcinia cochinchinensis", "Garcinia cornea", "Garcinia cowa", "Garcinia cymosa", "Garcinia dioica", "Garcinia dives", "Garcinia dulcis", "Garcinia epunctata", "Garcinia floribunda", "Garcinia forbesii", "Garcinia fusca", "Garcinia gardneriana", "Garcinia gerrardii", "Garcinia gibbsiae", "Garcinia griffithii", "Garcinia gummi-gutta", "Garcinia hanburyi", "Garcinia hombroniana", "Garcinia humilis", "Garcinia indica", "Garcinia intermedia", "Garcinia kola", "Garcinia kydia", "Garcinia lateriflora", "Garcinia livingstonei", "Garcinia loureiroi", "Garcinia macrophylla", "Garcinia madruno", "Garcinia mangostana", "Garcinia mestonii", "Garcinia mooreana", "Garcinia morella", "Garcinia multiflora", "Garcinia nigrolineata", "Garcinia oblongifolia", "Garcinia parvifolia", "Garcinia pedunculata", "Garcinia picrorhiza", "Garcinia portoricensis", "Garcinia prainiana", "Garcinia sciura", "Garcinia spicata", "Garcinia stipulata", "Garcinia subelliptica", "Garcinia syzygiifolia", "Garcinia venulosa", "Garcinia vidalii", "Garcinia wightii", "Garcinia xanthochymus"]

GM.rand_species = ->
  GM.initial_species[Math.floor(Math.random() * GM.initial_species.length)]

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
  token = Random.secret()
  token_record =
    token: token
    email: Meteor.users.findOne(user_id).emails[0].address
    when: new Date()
  Meteor.users.update user_id, $set: 'services.password.reset': token_record
  Meteor.absoluteUrl "enroll/#{user_id}/#{token}"

GM.sendEnrollmentEmail = (user_id) ->
  user = Meteor.users.findOne user_id
  Email.send
    from: '"GiggleGrist Team" <1786762946@qq.com>'
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
      avatar: String
    # 创建第一个Grist
    @userId = user_id
    grist_id = Meteor.call 'create_grist', options.username, options.avatar
    @userId = null
    Meteor.users.update user_id, $set: { 'profile.enrolled': true, 'profile.last_grist': grist_id, 'profile.chattypt': 0 }
  'create_grist': (name, avatar) ->
    if not @userId?
      throw new Meteor.Error 403, '搞笑！没登录怎么创建Grist！'
    if Grists.findOne(name: name)?
      throw new Meteor.Error 403, '真不敢相信……你要的名字居然已经被用掉了……'
    user = Meteor.user()
    if user.profile? and Grists.find({ _id: { $in: user.profile.grists }, is_random: false }).count() >= GM_level user.profile.chattypt
      throw new Meteor.Error 403, 'Grist数量超过限额！去讲讲话积攒一点话唠点数再来吧～'
    avatar ?= ''
    check avatar, String
    id = Random.id()
    Grists.insert
      _id: id
      name: name
      avatar: if avatar is '' then '' else Avatars.insert img: avatar
      colour: GM.hexToRgb Please.make_color()
      is_random: false
      timestamp: (new Date).getTime()
    console.log "第#{Grists.find().count()}个Grist被创建"
    Meteor.users.update @userId, $addToSet: 'profile.grists': id
    return id
  'modify_grist': (id, name, colour, avatar) ->
    if not @userId?
      throw new Meteor.Error 403, '貌似没登录？？'
    if Meteor.user().profile.grists.indexOf(id) is -1
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
    else if avatar isnt '' then modifier.$set.avatar = Avatars.insert img: avatar
    # 先发送广播
    grist = Grists.findOne id
    ghouses = []
    Messages.find('speaker._id': grist._id).forEach (m) ->
      if ghouses.indexOf(m.ghouse) is -1 then ghouses.push m.ghouse
    console.log '广播已发送：', ghouses
    if grist.name isnt name
      Meteor.call 'broadcast', ghouses, "[#{grist.name}] 把名字改为了 [#{name}]"
    if grist.colour.r isnt colour.r or grist.colour.g isnt colour.g or grist.colour.b isnt colour.b
      Meteor.call 'broadcast', ghouses, "[#{grist.name}] 更换了主题色"
    if modifier.$set.avatar?
      Meteor.call 'broadcast', ghouses, "[#{grist.name}] 更换了头像"
    Grists.update id, modifier
  'use_grist': (id) ->
    if not @userId?
      throw new Meteor.Error 403, '如果我没看错的话，你没登录'
    if Meteor.user().profile.grists.indexOf(id) is -1
      throw new Meteor.Error 403, '喂喂，不要乱动别人的东西哈'
    Meteor.users.update @userId, $set: 'profile.last_grist': id
  'create_ghouse': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '貌似你还没登录……'
    check options,
      title: NonEmptyString
      description: String
    options.id ?= Random.id()
    Greenhouses.insert
      _id: options.id
      title: options.title
      description: options.description
      creator: Meteor.user().profile.last_grist
      timestamp: (new Date).getTime()
  'modify_ghouse': (id, name, description) ->
    if not @userId? or Grists.findOne(Meteor.user().profile.last_grist)._id isnt Greenhouses.findOne(id).creator
      throw new Meteor.Error 403, '看错了吧？这是别人的玩意～～'
    Greenhouses.update id, $set: { name: name, description: description }
  'speak': (ghouse, message) ->
    if not @userId?
      throw new Meteor.Error 403, '你忘登录了！'
    check message, NonEmptyString
    if Greenhouses.find(ghouse).count() is 0
      throw new Meteor.Error 403, '木有这个房间'
    id = (Messages.find().count() + 1).toString()
    # 获取一个话唠点数
    Meteor.call 'get_chattypt', 1
    grist = Grists.findOne Meteor.user().profile.last_grist,
      fields: { _id: 1, name: 1, avatar: 1, colour: 1 }
    Messages.insert
      _id: id
      ghouse: ghouse
      speaker: grist
      message: message
      timestamp: (new Date).getTime()
  # TODO: 把这个保留在服务器内部，不能错客户端调用
  'broadcast': (ghouses, message) ->
    timestamp = (new Date).getTime()
    (Messages.insert
      _id: (Messages.find().count() + 1).toString()
      ghouse: ghouse
      speaker: 'broadcast'
      message: message
      timestamp: timestamp) for ghouse in ghouses
  'get_chattypt': (num) ->
    Meteor.users.update @userId, $inc: 'profile.chattypt': num
    Meteor.call 'update_random_grists'
  'update_random_grists': ->
    user = Meteor.user()
    level = GM_level user.profile.chattypt
    random_ct = Grists.find({ _id: { $in: user.profile.grists }, is_random: true }).count()
    while random_ct < level
      random_ct++
      id = Random.id()
      name = Meteor.call 'random_name'
      colour = GM.hexToRgb Please.make_color()
      Grists.insert
        _id: id
        name: name
        avatar: ''
        colour: colour
        is_random: true
        timestamp: (new Date).getTime()
      console.log "创建随机Grist #{id} #{name} #{colour.r},#{colour.g},#{colour.b}"
      Meteor.users.update @userId, $addToSet: 'profile.grists': id
    return
  'random_name': -> GM.rand_species()

Meteor.startup ->
  # 防止在Firefox内无法显示某些东东
  # 不解释，欲知详情请见GitHub上Pisces000221/plotipot/server/methods.coffee
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
  # 设置要发送的e-mail模板
  Accounts.emailTemplates.from = '"GiggleGrist Team" <1786762946@qq.com>'
  Accounts.emailTemplates.siteName = 'GiggleGrist'
