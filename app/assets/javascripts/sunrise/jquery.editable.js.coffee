$ = jQuery

$.fn.extend({
  editable: (options) ->
    $(this).each((input_field) ->
      new Editable(this, options)
    )
})

class Editable
  constructor: (@form_field, options = {}) ->
    this.setup()
    this.register_observers()
  
  setup: ->
    @element = $ @form_field
    
  register_observers: ->
    obj = this
    
    @element.bind 'click', (evt) =>
      unless @element.hasClass('disabled')
        switch @element.data('editable')
          when 'destroy' then this.destroy()
          when 'edit' then this.edit()
      false
    
  destroy: ->
    alert @element.attr('href')
      
  edit: ->
    alert @element.attr('href')
