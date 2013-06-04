require ['public/assets/javascripts/lib/components/availability_search.js'], (Availability) ->

  describe 'Availability', ->
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(Availability).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})

      it 'has an event listener constant', ->
        expect(av.config.LISTENER).toBeDefined()



    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'get search data', ->
      beforeEach ->
        loadFixtures('availability.html')

      describe 'with values', ->
        beforeEach ->
          window.av = new Availability({el: '.js-availability-card-with-values'})

        it 'serializes the search data', ->
          values = av._getSearchData()
          expectedResult =
            search:
              from: "06 Jun 2013"
              to: "07 Jun 2013"
              guests: "1"
              currency: "USD"
          expect(JSON.stringify(values, null, 2) is JSON.stringify(expectedResult, null, 2)).toBe(true)

      describe 'without values', ->
        beforeEach ->
          window.av = new Availability({el: '.js-availability-card'})
          spyOn(av, "_setDefaultDates")
          av._getSearchData()

        it 'sets the default dates', ->
          expect(av._setDefaultDates).toHaveBeenCalled()

    
    describe 'setting values', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card-with-values'})
        av._set("from", "test")

      it 'sets the start date', ->
        expect(av.$form.find('input[name*=from]').val()).toBe("test")


    describe 'showing', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card-hidden'})
        av._show()

      it 'removes the is-hidden class', ->
        expect(av.$el.hasClass('is-hidden')).toBe(false)


    describe 'hiding', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card'})
        av._hide()

      it 'adds the is-hidden class', ->
        expect(av.$el.hasClass('is-hidden')).toBe(true)


    describe 'blocking', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card'})
        av._block()

      it 'adds the disabled class', ->
        expect(av.$submit.hasClass('disabled')).toBe(true)

      it 'adds the disabled attribute', ->
        expect(av.$submit.attr('disabled')).toBe("disabled")

    describe 'unblocking', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card-blocked'})
        av._unblock()

      it 'removes the disabled class', ->
        expect(av.$submit.hasClass('disabled')).toBe(false)

      it 'adds the disabled attribute', ->
        expect(av.$submit.attr('disabled')).toBe(undefined)



    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'on page request', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_block")
        $(av.config.LISTENER).trigger(':page/request')

      it 'disables the availability form', ->
        expect(av._block).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_unblock")
        spyOn(av, "_set")
        spyOn(av, "_hide")

      describe 'if the user has searched', ->
        beforeEach ->
          spyOn(av, "hasSearched").andReturn(true)
          $(av.config.LISTENER).trigger(':page/received', {page_offsets: 2})
      
        it 'hides the availability form', ->
          expect(av._hide).toHaveBeenCalled()

        it 'enables the availability form', ->
          expect(av._unblock).toHaveBeenCalled()

        it 'updates the page offset', ->
          expect(av._set).toHaveBeenCalledWith("page_offsets", 2)

      describe 'if the user has not already searched', ->
        beforeEach ->
          spyOn(av, "hasSearched").andReturn(false)
          $(av.config.LISTENER).trigger(':page/received', {page_offsets: 2})

        it 'does not hide the availability form', ->
          expect(av._hide).not.toHaveBeenCalled()

        it 'enables the availability form', ->
          expect(av._unblock).toHaveBeenCalled()

        it 'updates the page offset', ->
          expect(av._set).toHaveBeenCalledWith("page_offsets", 2)


    describe 'on search', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_setDefaultDates").andReturn(true)
        spyOn(av, "_getSearchData").andReturn("foo")

      it 'triggers the page request event with the search data', ->
        spyEvent = spyOnEvent(av.$el, ':page/request');
        av.$form.trigger('submit')
        expect(':page/request').toHaveBeenTriggeredOnAndWith(av.$el, "foo")


    describe 'when the user wants to change dates', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_show")
        $(av.config.LISTENER).trigger(':search/change')

      it 'shows the availability form', ->
        expect(av._show).toHaveBeenCalled()

