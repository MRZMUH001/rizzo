required = if lp.isMobile then 'jsmin' else 'jquery'
define [required], ($)->

  class AssetReveal

    LISTENER = '#js-row--content'

    constructor: () ->
      @$listener = $(LISTENER)
      @listen() unless @$listener.length is 0

    # Subscribe
    listen: ->
      @$listener.on ':asset/uncomment', (e, elements, klass) =>
        elements = e.data[0] if elements is undefined
        klass = e.data[1] if klass is undefined
        @_uncomment(elements, klass)

      @$listener.on ':asset/uncommentScript', (e, elements, klass) =>
        @_uncommentScript(elements, klass)

      @$listener.on ':asset/loadBgImage', (e, elements) =>
        elements = e.data[0] if elements is undefined
        @_loadBgImage(elements)


    # Private

    _normaliseArray: (elements) ->
      if !!elements.splice then elements else [elements]

    _removeComments: (html) ->
      html.replace("<!--", "").replace("-->", "")

    _uncomment: (selector, klass = "[data-uncomment]") ->

      if window.lp.isMobile
        for elem in @_normaliseArray(selector)
          $commented = $(elem).find(klass)
          if $commented.length isnt 0
            inner = @_removeComments($commented.innerHTML)
            $commented.parentNode.innerHTML += inner
      else
        $commented = $(selector).find(klass).each( (i, node) =>
          inner = @_removeComments($(node).html())
          $(node).before(inner).remove()
        )

    # Uncommenting a script is a bit trickier if you want that script to be immediately executed
    # Currently only works with jquery (not yet required for mobile)
    _uncommentScript: (selector, klass = "[data-script]") ->
      process = (node) =>
        uncommented = @_removeComments(node.html())
        node.html(uncommented)

      for elem in @_normaliseArray(selector)
        $commented = $(elem).find(klass)
        process($commented) if $commented.length isnt 0

    _loadBgImage: (selector) ->
      $element = $(selector)
      if $element.hasClass('rwd-image-blocker')
        $element.removeClass('rwd-image-blocker')
      else
        $element.find('.rwd-image-blocker').removeClass('rwd-image-blocker')