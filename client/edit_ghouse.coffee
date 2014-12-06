Template.edit_ghouse.helpers
  'created_by_me': -> Meteor.user().profile.grists.indexOf(@creator) isnt -1

Template.edit_ghouse.events
  'click #btn_submit': ->
    name = document.getElementById('txt_name').value
    description = document.getElementById('txt_desc').value
    GM.modify_ghouse @_id, name, description, -> history.go -1
