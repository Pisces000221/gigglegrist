Meteor.subscribe 'messages'

Template.room.events
  'click #btn_send': ->
    msg = document.getElementById('txt_message').value
    if msg is '' then return
    document.getElementById('txt_message').value = ''
    GM.speak @_id, msg, ->
      # http://stackoverflow.com/q/11715646/
      # 加一个54是由于body的margin-bottom是54（见global.css），懒得用API获取了～
      window.scrollTo 0, document.body.scrollHeight + 54

Template.room.helpers
  'room_messages': -> GM.messages.find room: @_id
  'speaker_colour': -> window.rgba_colour @speaker.colour, 1
  'speaker_colour_fade': -> window.rgba_colour @speaker.colour, 0.2
  'speaker_name': -> @speaker.name
  'speaker_avatar': -> window.avatar @speaker
