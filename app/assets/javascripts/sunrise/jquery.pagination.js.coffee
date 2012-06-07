$ = jQuery

$.fn.extend({
  pagination: (options) ->
    # Do no harm and return as soon as possible for unsupported browsers, namely IE6 and IE7
    return this if $.browser.msie and ($.browser.version is "6.0" or $.browser.version is "7.0")
    $(this).each((input_field) ->
      el = $(this).data('pagination')
      el ?= new Pagination(this, options)
      return el
    )
})

class Pagination

  constructor: (@dom_element, options = {}) ->
    defaults =
      page: 1
      url: window.location.href
      params: {}
      method: 'GET'
      dataType: 'html'
      binder: window
      event: 'scroll'
      callback: null
      
    @options = $.extend defaults, options
    
    this._setup()
  
  _setup: ->
    @container = $(@dom_element)
    @container.data('pagination', this)
    @current_page = @options.page
    @disabled = false
    @root = @container.parent()
    @origin_url = window.location.href.split('#')[0]
    @binder = $(@options.binder)
    
    this._bind()
  
  _bind: ->
    switch @options.event
      when 'scroll' then @binder.bind('scroll', (e) => this.scroll(e))
      when 'click' then @binder.bind('click', (e) => this.click(e))
  
  load: ->
    @current_page += 1
    @disabled = true
    @options.params["time"] = new Date().getTime()
    
    $.ajax(
      url: this.options.url + "/p/" + @current_page
      type: this.options.method
      data: this.options.params
      dataType: this.options.dataType
      
      success: (data, status, xhr) =>
        this.append(data)
        @disabled = false
    )

  append: (data) ->
    if $.isFunction(@options.callback)
      @options.callback.apply(this, [data])
    else
      items = $(data).find('#' + @container.attr('id'))
      @container.append items.html()
    
    window.location.href = @origin_url + "#/p/" + @current_page
  
  scroll: (event) ->
    if @disabled
      event.stopPropagation()
    else
      pixelsFromWindowBottomToBottom = 0 + $(document).height() - @binder.scrollTop() - $(window).height()
      pixelsFromNavToBottom = $(document).height() - (@root.offset().top + @root.height())
        
      if (pixelsFromWindowBottomToBottom - pixelsFromNavToBottom <= 0)
        this.load()
    
    return true
  
  click: (event) ->
    this.load()
    return false
