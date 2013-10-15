describe 'plugin', ->
  options =
    message: 'Hello World'

  beforeEach ->
    loadFixtures 'fragment.html'
    @$element = $( '#fixtures' )

  describe 'plugin behavior', ->
    it 'should be available on the jQuery object', ->
      expect( $.fn.localLocker ).toBeDefined()

    it 'should be chainable', ->
      expect( @$element.localLocker() ).toBe @$element

    it 'should offer default values', ->
      plugin = new $.localLocker( @$element )

      expect( plugin.defaults ).toBeDefined()

    it 'should overwrites the settings', ->
      plugin = new $.localLocker( @$element, options )

      expect( plugin.settings.message ).toBe( options.message )

    it 'should be able to call hasStorage()', ->
      plugin = new $.localLocker( @$element )

      expect( plugin.hasStorage() ).toBeDefined()

    it 'should be able to call setData()', ->
      plugin = new $.localLocker( @$element )

      expect( plugin.setData() ).toBeDefined()

    it 'should be able to call getData()', ->
      plugin = new $.localLocker( @$element )

      expect( plugin.getData() ).toBeDefined()

    it 'should be able to call clearData()', ->
      plugin = new $.localLocker( @$element )

      expect( plugin.clearData() ).toBeDefined()


  describe 'plugin state', ->
    beforeEach ->
      @plugin = new $.localLocker( @$element )

    it 'should have a ready state', ->
      expect( @plugin.getState() ).toBe 'ready'

    it 'should be updatable', ->
      @plugin.setState( 'new state' )

      expect( @plugin.getState() ).toBe 'new state'