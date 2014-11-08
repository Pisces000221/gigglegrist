Template.edit_room.helpers
  'created_by_me': -> Meteor.user().profile.masks.indexOf(@creator) isnt -1

Template.edit_room.events
  'click #btn_submit': ->
    name = document.getElementById('txt_name').value
    description = document.getElementById('txt_desc').value
    GM.modify_room @_id, name, description, -> history.go -1
