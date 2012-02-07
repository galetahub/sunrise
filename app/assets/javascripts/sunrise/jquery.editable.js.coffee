$ = jQuery

$.fn.extend({
  editable: (options) ->
    new Editable(this, options)
})

class Editable
  constructor: (@fields, options = {}) ->
    this.setup()
    this.register_observers()
  
  setup: ->
    @elements = $ @fields
    @delete_button = @elements.filter('[data-editable=destroy]').first()
    @edit_button = @elements.filter('[data-editable=edit]').first()
    
  register_observers: ->  
    @elements.bind 'click', (evt) =>
      element = $(evt.target)
      
      unless element.hasClass('disabled')
        switch element.data('editable')
          when 'destroy' then this.destroy(element)
          when 'edit' then this.edit(element)
      false
    
    $('.check-block input').bind 'change', (evt) =>
      this.check_buttons()
      
    $('.but-holder .check input').bind 'change', (evt) =>
      $('.check-block input').prop("checked", $(evt.target).prop("checked"))
      this.check_buttons()
      
  check_buttons: ->
    count = $('.check-block input:checked').size()
    
    this.toggle_button count > 0, @delete_button
    this.toggle_button count == 1, @edit_button
    
  toggle_button: (condition, button) ->
    if condition then button.removeClass('disabled') else button.addClass('disabled')
    
  destroy: (element) ->
    if this.allowAction(@delete_button)
      this.handleMethod(element, 'delete')
      
  edit: (element) ->
    item = $('.check-block input:checked').first()
    location = element.attr('href').replace('0', item.val())
    window.location = location
    
  allowAction: (element) ->
    message = element.data('confirm-message')
    answer = false
    # callback;
    if !message 
      return true

    if $.rails.fire(element, 'confirm') 
      answer = $.rails.confirm(message)
      callback = $.rails.fire(element, 'confirm:complete', [answer])
    
    answer && callback
    
  handleMethod: (link, method) ->
    href = link.attr('href')
    csrf_token = $('meta[name=csrf-token]').attr('content')
    csrf_param = $('meta[name=csrf-param]').attr('content')
    form = $('<form method="post" action="' + href + '"></form>')
    metadata_input = '<input name="_method" value="' + method + '" type="hidden" />'
    
    $('.check-block input:checked').each (index, element) ->
      metadata_input += '<input name="ids[]" value="' + $(element).val() + '" type="hidden" />'

    if csrf_param? and csrf_token?
      metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />'

    form.hide().append(metadata_input).appendTo('body')
    form.submit()
