# Configure iron:router

Router.map ->
  # 一般页面（没有id作为参数）
  @route 'welcome',
    path: '/'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'room_list',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'enrollment',
    path: '/enroll/:user_id'
    data: -> @params.user_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
