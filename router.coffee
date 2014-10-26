# Configure iron:router

Router.map ->
  @route 'home_page',
    path: '/'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'enrollment',
    path: '/enroll/:user_id'
    data: -> @params.user_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'man_masks',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'edit_mask',
    path: '/edit_mask/:id'
    data: -> GM.masks.findOne @params.id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'room',
    path: '/room/:id'
    data: -> GM.rooms.findOne @params.id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
