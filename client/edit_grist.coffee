Session.setDefault 'removed_avatar', false
Session.setDefault 'edit_grist_msg', ''
Session.setDefault 'edit_grist_in_progress', false

Template.edit_grist.created = ->
  window.load_script '/external/jscolor/jscolor.js'
  Session.set 'removed_avatar', false

init_jscolor = (t) ->
  e = document.getElementById 'txt_colour'
  if not e.color?
    jscolor.init()
    e.color.fromRGB t.colour.r / 255, t.colour.g / 255, t.colour.b / 255

Template.edit_grist.helpers
  'message': -> Session.get 'edit_grist_msg'
  'in_progress': -> Session.get 'edit_grist_in_progress'

Template.edit_grist.events
  'focus #txt_colour': -> init_jscolor(this)
  'click #btn_rm_avatar': -> Session.set 'removed_avatar', true
  'click #btn_submit': ->
    Session.set 'edit_grist_msg', ''
    Session.set 'edit_grist_in_progress', true
    init_jscolor(this)
    reader = new FileReader()

    name = document.getElementById('txt_name').value
    c = document.getElementById('txt_colour').color.rgb
    colour = r: Math.round(c[0] * 255), g: Math.round(c[1] * 255), b: Math.round(c[2] * 255)
    picker = document.getElementById 'file_avatar'
    avatar = ''
    reading_new_avatar = false
    id = @_id

    reader.onloadend = ->
      # 文件加载完成
      avatar = reader.result if reading_new_avatar
      GM.modify_grist id, name, colour, avatar, (err, result) ->
        if err then Session.set 'edit_grist_msg', "出了点问题…… #{err.toString()}"
        else history.back()
        Session.set 'edit_grist_in_progress', false
      return

    if picker? and picker.files.length isnt 0
      # 新的头像
      reading_new_avatar = true
      reader.readAsDataURL picker.files[0]
    else
      if Session.get 'removed_avatar'
        # 删除头像
        avatar = 'remove'
      reader.onloadend()
