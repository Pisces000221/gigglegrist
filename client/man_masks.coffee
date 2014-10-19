Template.man_masks.helpers
  'my_masks': -> GM.masks.find _id: $in: Meteor.user().profile.masks
