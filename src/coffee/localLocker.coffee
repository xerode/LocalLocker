#
# _name    : LocalLocker
# Author  : Paul Bennett, http://xerode.net, @xerode
# Version : 0.0.1
# Repo    : https://github.com/xerode/LocalLocker
# Website : https://github.com/xerode/LocalLocker
#

jQuery ->
  $.localLocker = ( element, options ) ->
    # Internal variables
    state = ''
    lastSave = 0
    data = {}

    # Internal classes for handling data
    class StorageData
      tmp: 'tmp'
      constructor: ->
        console.log 'StorageData'

    class LocalStorageData extends StorageData
      set: (_name,_value) ->
        # console.log( "LocalStorageData.set( " + _name + ", " + _value + " )" )
        localStorage.setItem( _name, JSON.stringify( _value ) )
        @lastSave = new Date()
        return true

      get: (_name) ->
        # console.log( "LocalStorageData.get( " + _name + " )" )
        if localStorage.getItem( _name )? then return JSON.parse( localStorage.getItem( _name ) )
        return false

      clear: (_name) ->
        if _name? then localStorage.removeItem( _name ) else localStorage.clear()
        return true

    class SessionStorageData extends LocalStorageData
      set: (_name,_value) ->
        # console.log( "LocalStorageData.set( " + _name + ", " + _value + " )" )
        sessionStorage.setItem( _name, JSON.stringify( _value ) )
        @lastSave = new Date()
        return true

      get: (_name) ->
        # console.log( "LocalStorageData.get( " + _name + " )" )
        if sessionStorage.getItem( _name )? then return JSON.parse( sessionStorage.getItem( _name ) )
        return false

      clear: (_name) ->
        if _name? then sessionStorage.removeItem( _name ) else sessionStorage.clear()
        return true

    class CookieData extends StorageData
      constructor: ->
        super
        console.log 'CookieData'
        tmp = 'overwrite'

    class SessionCookieData extends CookieData
      constructor: ->
        super
        console.log 'SessionCookieData'
        tmp = 'overwrite'

    # plugin settings
    @settings = {}
    @defaults = 
      session: false
      useCookie: false
      cookie_name: 'localLocker'
      cookieDomain: '*'
      cookieExpiry: 0

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
    @callSettingFunction = ( _name, args = [] ) ->
      @settings[_name].apply( this, args )

    @init = ->

      console.log( "init" )

      @settings = $.extend( {}, @defaults, options )

      data = @getDataLayer()

      console.log( 'data.tmp == ' + data.tmp )

      @setState 'ready'

    @getDataLayer = ->

      if !@hasStorage() or @settings.useCookie
        # No localStorage support, or explicitly said to use cookies
        if @settings.session then return new SessionCookieData() else return new CookieData()
      else
        if @settings.session then return new SessionStorageData() else return new LocalStorageData()

      return false

    @hasStorage = ->
      Storage? and localStorage? and sessionStorage?

    @setData = ( _name, _value ) ->
      console.log( "setData( " + _name + ", " + _value + " )" )
      data.set( _name, _value )

    @getData = ( _name ) ->
      console.log( "getData( " + _name + " )" )
      data.get( _name )

    @clearData = ( _name ) ->
      console.log( "clearData" )
      data.clear( _name )

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  $.fn.localLocker = ( options ) ->
    this.each ->
      if $( this ).data( 'localLocker' ) is undefined
        plugin = new $.localLocker( this, options )
        $( this ).data( 'localLocker', plugin )
