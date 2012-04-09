root = this
$ = jQuery

class Sunrise
  constructor: (@namespace) ->
    
  setup: ->
    ($ '[title]').tooltip()
    ($ ".chzn-select").chosen()
    ($ ".ddmenu").ddmenu()
    ($ '[data-editable]').editable()
    ($ '[data-lang]').lang_tabs()
    
    this.init_submit_buttons()
  
  getParameterByName: (name) ->
    match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search)
    if match then decodeURIComponent(match[1].replace(/\+/g, ' ')) else null

  init_sort_select: ->
    $("#sort").bind 'change', (evt) ->
      this.form.submit()
      
  init_submit_buttons: ->
    $('#cancel-submit-form-button').bind 'click', (evt) ->
      window.history.back()
    
    $('#submit-form-button').bind 'click', (evt) ->
      $('form:first').submit()
    

  # Store params: page, per, sort and view for current namespace
  storeQuery: () ->
    query = {}
    self = this
    
    $.each ['page', 'per', 'sort', 'view'], (index) ->
      value = self.getParameterByName(this)
      query[this] = value if value?
      
    $.cookie('params', $.param(query), { expires: 30, path: @namespace })

$(document).ready ->
  window['sunrise'] ?= new Sunrise(window.location.pathname)
  window['sunrise'].setup()
