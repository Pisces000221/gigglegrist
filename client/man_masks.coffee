Template.man_masks.helpers
  'my_masks': -> GM.masks.find _id: $in: Meteor.user().profile.masks
  'my_avatar': -> if @avatar is '' then 'http://www.gravatar.com/avatar/00000000000000000000000000000001?d=identicon' else @avatar
  # 'selected': -> 'active' if Meteor.user().profile.last_mask is @_id
  'colours': ->
    alpha = if Meteor.user().profile.last_mask isnt @_id then 0.35 else 1.0
    "color: #000; background-color: rgba(#{@colour.r}, #{@colour.g}, #{@colour.b}, #{alpha})"
