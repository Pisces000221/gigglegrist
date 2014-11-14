Meteor.subscribe 'messages'

Template.ghouse.rendered = -> window.scroll_to_bottom()

Template.ghouse.events
  'click #btn_send': ->
    msg = document.getElementById('txt_message').value
    if msg is '' then return
    document.getElementById('txt_message').value = ''
    GM.speak @_id, msg, -> window.scroll_to_bottom()

Template.ghouse.helpers
  'ghouse_messages': -> GM.messages.find ghouse: @_id
  'is_broadcast': -> @speaker is 'broadcast'
  'speaker_colour': -> window.rgba_colour @speaker.colour, 1
  'speaker_colour_fade': -> window.rgba_colour @speaker.colour, 0.2
  'speaker_name': -> @speaker.name
  'speaker_avatar': -> window.avatar @speaker
  'created_by_me': -> Meteor.user().profile.masks.indexOf(@creator) isnt -1
