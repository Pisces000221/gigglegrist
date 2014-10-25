Template.header.events
  'click #a_logout': -> Meteor.logout()

Meteor.subscribe 'masks'

Session.setDefault 'logged_in', false
Tracker.autorun -> Session.set 'logged_in', Meteor.userId()?

Template.registerHelper 'current_username', -> Meteor.user().emails[0].address
Template.registerHelper 'current_maskname', -> GM.masks.findOne(Meteor.user().profile.last_mask).name
Template.registerHelper 'logged_in', -> Session.get 'logged_in'

Template.registerHelper 'my_masks', -> GM.masks.find _id: $in: Meteor.user().profile.masks
Template.registerHelper 'cur_avatar', -> if @avatar is '' then 'http://www.gravatar.com/avatar/' + md5(@_id) + '?d=identicon' else @avatar
