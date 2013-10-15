#
# Name    : LocalLocker
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

      set: (name,value) ->
        localStorage.setItem(name,JSON.stringify(value))
        @lastSave = new Date()

      get: (name) ->
        if localStorage.getItem(name)? then return JSON.parse(localStorage.getItem(name)) else return false

    class SessionStorageData extends LocalStorageData
      set: (name,value) ->
        sessionStorage.setItem(name,JSON.stringify(value))
        @lastSave = new Date()

      get: (name) ->
        if sessionStorage.getItem(name)? then return JSON.parse(sessionStorage.getItem(name)) else return false

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
      message: 'Hello world'
      session: false
      useCookie: false
      cookieName: 'localLocker'

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

      data = @getDataLayer()

      console.log( 'data.tmp == ' + data.tmp )

      @setState 'ready'

    @getDataLayer = ->

      if !@hasStorage() or @settings.useCookie
        if @settings.session then return new SessionCookieData else return new CookieData
      else
        if @settings.session then return new SessionStorageData else return new LocalStorageData

      return false

    @hasStorage = ->
      return Storage? and localStorage? and sessionStorage?

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  $.fn.localLocker = ( options ) ->
    this.each ->
      if $( this ).data( 'localLocker' ) is undefined
        plugin = new $.localLocker( this, options )
        $( this).data( 'localLocker', plugin )