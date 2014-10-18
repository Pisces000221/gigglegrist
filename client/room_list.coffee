Meteor.subscribe 'rooms'

Template.room_list.helpers
  'all_rooms': -> GM.rooms.find()
