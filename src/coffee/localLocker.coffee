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
      set: ( _name, _value ) ->
        localStorage.setItem( _name, JSON.stringify( _value ) )
        @lastSave = new Date()
        return true

      get: ( _name ) ->
        if localStorage.getItem( _name )? then return JSON.parse( localStorage.getItem( _name ) )
        return false

      clear: ( _name ) ->
        if _name? then localStorage.removeItem( _name ) else localStorage.clear()
        return true

    class SessionStorageData extends LocalStorageData
      set: ( _name, _value ) ->
        sessionStorage.setItem( _name, JSON.stringify( _value ) )
        @lastSave = new Date()
        return true

      get: ( _name ) ->
        if sessionStorage.getItem( _name )? then return JSON.parse( sessionStorage.getItem( _name ) )
        return false

      clear: ( _name ) ->
        if _name? then sessionStorage.removeItem( _name ) else sessionStorage.clear()
        return true

    class CookieData extends StorageData
      store: {}
      settings:
        name: 'localLocker'
        domain: window.location.host.toString()
        path: '/'
        expiration: new Date()

      constructor: ->
        console.log 'CookieData'
        # Build store out of existing cookie data
        # Might need to use RegExp.escape( @settings.name ) here
        # @store = JSON.parse( document.cookie.match( new RegExp( '=(\{.+\})' ) )[ 1 ] )

      set: ( _name, _value ) ->
        @store[ _name ] = _value
        @settings.expiration.setTime( @settings.expiration.getTime() + 90000 )
        @bakeCookie()
        return true

      get: ( _name ) ->
        if @store[ _name ]?
          return @store[ _name ]
        else if document.cookie?
          # Might need to use RegExp.escape( @settings.name ) here
          result = document.cookie.match( new RegExp( '=(\{.+\})' ) )
          return JSON.parse( result[ 1 ] )[ _name ] || false
        return false

      bakeCookie: ->
        cookie = [ @settings.name, '=', JSON.stringify( @store ), ';', 'expires=', @settings.expiration, ';', 'domain=', @settings.domain, ';', 'path=', @settings.path, ';' ].join( '' )
        console.log( 'bakeCookie: ' + cookie )
        document.cookie = cookie

    class SessionCookieData extends CookieData
      constructor: ->
        console.log 'SessionCookieData'

    # plugin settings
    @settings = {}
    @defaults = 
      session: false
      useCookie: false
      # Put following as properties of cookie classes?
      cookieName: 'localLocker'
      cookieDomain: window.location.host.toString()
      cookieExpiry: 0
      cookiePath: '/'

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

      @settings = $.extend( {}, @defaults, options )

      data = @getDataLayer()

      # console.log( "Cookies == " + document.cookie )

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
      data.set( _name, _value )

    @getData = ( _name ) ->
      data.get( _name )

    @clearData = ( _name ) ->
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
