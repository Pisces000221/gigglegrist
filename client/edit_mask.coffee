Session.setDefault 'jscolor_initialized', false

Template.edit_mask.created = ->
  window.load_script '/external/jscolor/jscolor.js'

Template.edit_mask.events
  'focus #txt_colour': ->
    if not Session.get 'jscolor_initialized'
      jscolor.init()
      e = document.getElementById 'txt_colour'
      e.color.fromRGB @colour.r / 255, @colour.g / 255, @colour.b / 255
    Session.set 'jscolor_initialized', true
