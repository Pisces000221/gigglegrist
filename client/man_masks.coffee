Session.setDefault 'man_masks_msg', ''

Template.man_masks.events
  'click #btn_create_mask': ->
    GM.create_mask document.getElementById('txt_mask_name').value, (err, result) ->
      if err then Session.set 'man_masks_msg', err.toString()
      else Session.set 'man_masks_msg', ''
      document.getElementById('txt_mask_name').value = ''
  'click .btn_use_mask': -> GM.use_mask @_id

Template.man_masks.helpers
  'message': -> Session.get 'man_masks_msg'
  'colours': ->
    alpha = if Meteor.user().profile.last_mask isnt @_id then 0.35 else 1.0
    "color: #000; background-color: rgba(#{@colour.r}, #{@colour.g}, #{@colour.b}, #{alpha})"
  'is_selected': -> Meteor.user().profile.last_mask is @_id
