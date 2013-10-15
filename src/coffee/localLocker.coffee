#
# Name    : LocalLocker
# Author  : Paul Bennett, http://xerode.net, @xerode
# Version : 0.0.1
# Repo    : https://github.com/xerode/LocalLocker
# Website : https://github.com/xerode/LocalLocker
#

jQuery ->
  $.localLocker = ( element, options ) ->
    # current state
    state = ''
    lastSave = 0

    # plugin settings
    @settings = {}
    @defaults = 
      message: "Hello world"
      useCookie: false
      session: false

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    # set current state
    @setState = ( _state ) -> state = _state

    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = ( key ) ->
      @settings[ key ]

    # call one of the plugin setting functions
    @callSettingFunction = ( name, args = [] ) ->
      @settings[name].apply( this, args )

    @init = ->
      @settings = $.extend( {}, @defaults, options )

      if !@hasStorage() or @settings.useCookie then console.log 'use Cookie' else console.log 'use localStorage'

      @setState 'ready'

    @hasStorage = ->
      Storage?

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  $.fn.localLocker = ( options ) ->
    this.each ->
      if $( this ).data( 'localLocker' ) is undefined
        plugin = new $.localLocker( this, options )
        $( this).data( 'localLocker', plugin )