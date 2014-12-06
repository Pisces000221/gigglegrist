Meteor.subscribe 'ghouses'

Session.setDefault 'ghouse_list_msg', ''

Template.ghouse_list.events
  'click #btn_create_ghouse': ->
    GM.create_ghouse
      title: document.getElementById('txt_ghouse_name').value
      description: '', (err, result) ->
        if err then Session.set 'ghouse_list_msg', err.toString()
        else Session.set 'ghouse_list_msg', ''; document.getElementById('txt_ghouse_name').value = ''

Template.ghouse_list.helpers
  'message': -> Session.get 'ghouse_list_msg'
  'all_ghouses': -> GM.ghouses.find()
  'load_finished': -> GM.ghouses.find().count() > 0
  'creator_name': -> GM.grists.findOne(@creator).name
