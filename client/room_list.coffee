Meteor.subscribe 'rooms'

Session.setDefault 'room_list_msg', ''

Template.room_list.events
  'click #btn_create_room': ->
    GM.create_room
      title: document.getElementById('txt_room_name').value
      description: '', (err, result) ->
        if err then Session.set 'room_list_msg', err.toString()
        else Session.set 'room_list_msg', ''; document.getElementById('txt_room_name').value = ''

Template.room_list.helpers
  'message': -> Session.get 'room_list_msg'
  'all_rooms': -> GM.rooms.find()
