# http://stackoverflow.com/questions/5623838/
hexToRgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex
  if result then {
      r: parseInt result[1], 16
      g: parseInt result[2], 16
      b: parseInt result[3], 16
  }
  else null

Template.man_masks.helpers
  'my_masks': -> GM.masks.find _id: $in: Meteor.user().profile.masks
  'my_avatar': -> if @avatar is '' then 'http://www.gravatar.com/avatar/00000000000000000000000000000001?d=identicon' else @avatar
  # 'selected': -> 'active' if Meteor.user().profile.last_mask is @_id
  'colours': ->
    c = hexToRgb(@colour)
    alpha = if Meteor.user().profile.last_mask isnt @_id then 0.35 else 1.0
    "color: #000; background-color: rgba(#{c.r}, #{c.g}, #{c.b}, #{alpha})"
