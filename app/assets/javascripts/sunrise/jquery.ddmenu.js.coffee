root = this
$ = jQuery

$.fn.extend({
  ddmenu: (options) ->
    # Do no harm and return as soon as possible for unsupported browsers, namely IE6 and IE7
    return this if $.browser.msie and $.browser.version is "6.0"
    $(this).each((input_field) ->
      new DropdownMenu(this, options) unless ($ this).hasClass "ddm-done"
    )
})

class DropdownMenu

  constructor: (@form_field, options = {}) ->
    defaults =
      activation: "click"
      attribute: "rel"
      fadeIn: 200,
      fadeOut: 200,
      delay: 400
    
    @options = $.extend defaults, options
    
    this.setup()
    this.register_observers()
  
  setup: ->
    @element = $ @form_field
    @element.addClass "ddm-done"
    
    dom_id = @element.attr(@options.attribute) + '-container'
    
    @container = $ '#' + dom_id
    @container.addClass('ddm-container')
    @container.hide()
  
  register_observers: ->
    @element.bind @options.activation, (evt) => this.activate(evt)
  
  activate: (event) ->
    if @element.hasClass('ddm-active')
      this.hide event
    else
      this.show event
    
    return false
  
  killer: ->
    $(document).bind 'click.ddmenu', (evt) =>
      event = evt || root.window.event
      target = event.target || event.srcElement
      node = $(target)
      
      this.hide() if !node.hasClass('ddm-container') and node.parents('.ddm-container').length is 0
  
  show: (event) ->
    @element.addClass "ddm-active"
    this.fadeIn()
    
    this.killer()
  
  fadeIn: ->
    @container.stop(true, true).fadeIn @options.fadeIn
  
  hide: (event) ->
    @element.removeClass "ddm-active"
    @container.fadeOut(@options.fadeOut)
    
    $(document).unbind 'click.ddmenu'
    
