Meteor.subscribe 'messages'

Template.room.helpers
  'room_messages': -> GM.messages.find room: @_id
  'speaker_colour': -> window.rgba_colour GM.masks.findOne(@speaker).colour, 1
  'speaker_colour_fade': -> window.rgba_colour GM.masks.findOne(@speaker).colour, 0.2
  'speaker_name': -> GM.masks.findOne(@speaker).name
  'speaker_avatar': -> window.avatar GM.masks.findOne(@speaker)
