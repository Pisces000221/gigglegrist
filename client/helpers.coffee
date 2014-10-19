Template.header.events
  'click #a_logout': -> Meteor.logout()

Meteor.subscribe 'masks'

Session.setDefault 'logged_in', false
Tracker.autorun -> Session.set 'logged_in', Meteor.userId()?

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
Template.registerHelper 'current_maskname', -> GM.masks.findOne(Meteor.user().profile.last_mask).name
Template.registerHelper 'logged_in', -> Session.get 'logged_in'
