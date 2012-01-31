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
    @container.find("a[submenu]").bind 'click', (evt) => this.submenu(evt)
  
  activate: (event) ->
    if @element.hasClass('ddm-active')
      this.hide event
    else
      this.show event
    
    return false
  
  killer: ->
    $(document).trigger 'click.ddmenu'
    $(document).unbind 'click.ddmenu'
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
    #@container.stop(true, true).fadeIn @options.fadeIn
    @container.stop(true, true).slideDown @options.fadeIn
  
  hide: (event) ->
    @element.removeClass "ddm-active"
    #@container.fadeOut(@options.fadeOut)
    @container.slideUp(@options.fadeOut)
    
    $(document).unbind 'click.ddmenu'
  
  submenu: (event) ->
    target = event.target || event.srcElement
    node = $ target
    
    if not node.attr('id')?
      node.attr('id', 'menu-' + this.generate_id())
    
    options =
      url: node.attr 'href' 
      type: 'GET'
      dataType: 'json'
      success: (data, status, xhr) =>
        this.populate data, node.attr('id')
        
    $.rails.ajax options
    
    return false
  
  populate: (data, dom_id) ->
    list_id = 'sub' + dom_id
    
    if $('#' + list_id).length == 0
      list = $("<ul></ul>", {class: "inner-list", id: list_id })
      node = @container.find('div.sub-inner')
      node.append list      
    else
      list = $('#' + list_id)
    
    list.html ""
    
    $.each data, (index) ->
      ul = $("<li></li>")
      link = $("<a></a>", {href: this.url })
      link.html this.title
      list.append ul.append(link)
    
    list.next("ul").remove()
    
  
  generate_id: (len = 5, possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') ->
    randomString = ''
    
    for num in [0..len]
      randomPoz = Math.floor(Math.random() * possible.length)
      randomString += possible.substring(randomPoz, randomPoz+1)
      
    return randomString

    
