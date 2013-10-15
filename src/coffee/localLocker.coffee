#
# Name    : <plugin name>
# Author  : <your name>, <your website url>, <twitter handle>
# Version : <version number>
# Repo    : <repo url>
# Website : <website url>
#

jQuery ->
  $.localLocker = ( element, options ) ->
    # current state
    state = ''

    # plugin settings
    @settings = {}
    @defaults = 
      message: "Hello world"

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

      # console.log( 'init gs ' + @getSetting( 'message' ) + " hasStorage? " + @hasStorage() )

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