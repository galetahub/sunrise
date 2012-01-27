root = this
$ = jQuery

$.fn.extend({
  tooltip: (options) ->
    # Do no harm and return as soon as possible for unsupported browsers, namely IE6 and IE7
    return this if $.browser.msie and ($.browser.version is "6.0" or $.browser.version is "7.0")
    $(this).each((input_field) ->
      new ToolTip(this, options) unless ($ this).hasClass "tt-done"
    )
})

class ToolTip

  constructor: (@form_field, options = {}) ->
    defaults =
      activation: "hover"
      keepAlive: false
      edgeOffset: 3
      position: "bottom"
      delay: 400
      fadeIn: 200
      fadeOut: 200
      attribute: "title"
      content: false
      container_id: "tt-container"
    
    @options = $.extend defaults, options
    
    this.setup()
    this.register_observers()
  
  setup: ->
    @element = $ @form_field
    @element.addClass "tt-done"
    
    text = @element.attr @options.attribute
    @element.data 'tt-text', text
    @element.removeAttr @options.attribute
    
    @container = this.create_container(@options.container_id)
    @container.hide()
  
  create_container: (dom_id = 'tt-container') ->
    container = $ '#' + dom_id
    
    if container.length is 0
      holder = ($ '<div></div>', {class:"black-note", id: dom_id})
      content = $ '<div class="note-holder"></div>'
      ($ "body").append holder.html(content)
      holder
    else
      container
  
  register_observers: ->
    @element.bind @options.activation, (evt) => this.activate(evt)
  
  activate: (event) ->
    if @element.hasClass('tt-active')
      this.hide event
    else
      this.show event
  
  show: (event) ->
    text = @element.data 'tt-text'
    @container.find('div.note-holder').html(text)

    pos = this.position()
    
    @container.css { position: "absolute", left: pos.left + "px", top: pos.top + "px", zIndex: 1001}
    @element.addClass "tt-active"
    
    clearTimeout @timeout if @timeout
    @timeout = setTimeout (=> this.fadeIn()), @options.delay
  
  fadeIn: ->
    @container.stop(true, true).fadeIn @options.fadeIn
  
  hide: (event) ->
    @element.removeClass "tt-active"
    
    clearTimeout @timeout if @timeout
    @container.fadeOut(@options.fadeOut)
  
  position: ->
    width = @container.outerWidth()
    height = @container.outerHeight()
      
    el_width = @element.outerWidth()
    el_height = @element.outerHeight()
    
    target = if @element.css('position') is 'absolute' then @element.parents('div') else @element
    pos = target.offset()
    
    { left: (pos.left - width / 2 + el_width / 2), top: (pos.top + el_height + 7) }
    
