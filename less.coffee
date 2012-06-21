
path = require 'path'
fs = require 'fs'

less = require 'less'

exports.compile = (outfile, options, callback) ->
  if options.overrideFile
    filename = path.join process.cwd(), options.overrideFile
  else
    filename = path.join __dirname,'custom.less'

  filename = path.relative process.cwd(), filename

  lessData = variableMixin filename, options.responsive

  parser = new(less.Parser)
    paths: ['.',(path.join __dirname,'node_modules/bootstrap/less')]

  parser.parse lessData, (e, tree) ->
    callback e if e
    try
      options.compress ?= true
      css = tree.toCSS 
        compress: options.compress

      fs.writeFile outfile, css, callback
    catch error
      callback error

variableMixin = (override_name, responsive) ->
  main = """
  /*!
   * Bootstrap v2.0.4
   *
   * Copyright 2012 Twitter, Inc
   * Licensed under the Apache License v2.0
   * http://www.apache.org/licenses/LICENSE-2.0
   *
   * Designed and built with all the love in the world @twitter by @mdo and @fat.
   */

  // CSS Reset
  @import "reset.less";

  // Core variables and mixins
  @import "variables.less";
  @import "mixins.less";

  // Custom overrides
  @import "#{override_name}";

  // Grid system and page structure
  @import "scaffolding.less";
  @import "grid.less";
  @import "layouts.less";

  // Base CSS
  @import "type.less";
  @import "code.less";
  @import "forms.less";
  @import "tables.less";

  // Components: common
  @import "sprites.less";
  @import "dropdowns.less";
  @import "wells.less";
  @import "component-animations.less";
  @import "close.less";

  // Components: Buttons & Alerts
  @import "buttons.less";
  @import "button-groups.less";
  @import "alerts.less"; // Note: alerts share common CSS with buttons and thus have styles in buttons.less

  // Components: Nav
  @import "navs.less";
  @import "navbar.less";
  @import "breadcrumbs.less";
  @import "pagination.less";
  @import "pager.less";

  // Components: Popovers
  @import "modals.less";
  @import "tooltip.less";
  @import "popovers.less";

  // Components: Misc
  @import "thumbnails.less";
  @import "labels-badges.less";
  @import "progress-bars.less";
  @import "accordion.less";
  @import "carousel.less";
  @import "hero-unit.less";

  // Utility classes
  @import "utilities.less"; // Has to be last to override when necessary

  """
  resp =
  """

  // Responsive.less
  // For phone and tablet devices
  // -------------------------------------------------------------

  // RESPONSIVE CLASSES
  // ------------------

  @import "responsive-utilities.less";


  // MEDIA QUERIES
  // ------------------

  // Phones to portrait tablets and narrow desktops
  @import "responsive-767px-max.less";

  // Tablets to regular desktops
  @import "responsive-768px-979px.less";

  // Large desktops
  @import "responsive-1200px-min.less";


  // RESPONSIVE NAVBAR
  // ------------------

  // From 979px and below, show a button to toggle navbar contents
  @import "responsive-navbar.less";

  """
  main  = main.concat resp if responsive
  main

