Meteor.subscribe 'messages'

Template.room.helpers
  'room_messages': -> GM.messages.find room: @_id
  'speaker_colour': -> window.rgba_colour GM.masks.findOne(@speaker).colour, 255
  'speaker_name': -> GM.masks.findOne(@speaker).name
