Meteor.subscribe 'messages'

Template.room.events
  'click #btn_send': ->
    msg = document.getElementById('txt_message').value
    if msg is '' then return
    GM.speak @_id, msg, ->
      document.getElementById('txt_message').value = ''
      # http://stackoverflow.com/q/11715646/
      window.scrollTo 0, document.body.scrollHeight

Template.room.helpers
  'room_messages': -> GM.messages.find room: @_id
  'speaker_colour': -> window.rgba_colour GM.masks.findOne(@speaker).colour, 1
  'speaker_colour_fade': -> window.rgba_colour GM.masks.findOne(@speaker).colour, 0.2
  'speaker_name': -> GM.masks.findOne(@speaker).name
  'speaker_avatar': -> window.avatar GM.masks.findOne(@speaker)
