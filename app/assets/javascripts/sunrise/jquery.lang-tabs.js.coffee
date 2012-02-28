$ = jQuery

$.fn.extend({
  lang_tabs: (options) ->
    new LangTabs(this, options)
})

class LangTabs
  constructor: (@fields, options = {}) ->
    this.setup()
    this.register_observers()
  
  setup: ->
    @elements = $ @fields
    
    current_lang = $('#lang-tabs').data('current-lang')

    @elements.each (index, item) =>
      elem = $(item)
      
      if elem.data('lang') == current_lang
        elem.hide()
        elem.next('span').show()
        $('.lang-' + current_lang).show()
        
    
  register_observers: ->  
    @elements.bind 'click', (evt) =>
      element = $(evt.target)
      
      @elements.next('span').hide()
      @elements.show()
      element.next('span').show()
      element.hide()
      
      $('.lang-block').hide()
      $('.lang-' + element.data('lang')).show()
