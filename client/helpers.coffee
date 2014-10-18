Template.header.events
  'click #a_logout': -> Meteor.logout()

Meteor.subscribe 'masks'

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
Template.registerHelper 'current_maskname', -> GM.masks.findOne(Meteor.user().profile.last_mask).name
