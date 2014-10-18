Template.header.events
  'click #a_logout': -> Meteor.logout()

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
