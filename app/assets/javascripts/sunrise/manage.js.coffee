root = this
$ = jQuery

class Sunrise
  constructor: (@namespace) ->
    
  setup: ->
    ($ '[title]').tooltip()
    ($ ".ddmenu").ddmenu()
    ($ '[data-editable]').editable()
    ($ '[data-lang]').lang_tabs()
    ($ "select.select:hidden").css("width", "225")
    ($ "select.select").chosen(
      allow_single_deselect: true
      disable_search_threshold: 10
    )
    
    this.init_submit_buttons()
    this.init_group_menus()
  
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

  init_group_menus: ->
    $(".title-switcher").bind('click', (e) ->
      $(this).parent().find(".padder").toggle()

      if $(this).hasClass('up')
        $(this).removeClass('up').addClass('down')
      else
        $(this).removeClass('down').addClass('up')

      return false
    )

  # Store params: page, per, sort and view for current namespace
  storeQuery: () ->
    query = {}
    self = this
    
    $.each ['page', 'per', 'sort', 'view'], (index) ->
      value = self.getParameterByName(this)
      query[this] = value if value?
      
    $.cookie('params', $.param(query), { expires: 30, path: @namespace })
  
  serialize: (items, options) ->
    str = []
    defaults = 
      attribute: 'id'
      listType: 'ul'
      expression: /(.+)[-=_](.+)/
      key: null
      
    o = $.extend defaults, options

    $(items).each((index) ->
      res = ($(o.item || this).attr(o.attribute) || '').match(o.expression)
      pid = ($(o.item || this).parent(o.listType).parent('li').attr(o.attribute) || '').match(o.expression)

      if (res)
        idx = 2#if o.key and o.expression then 1 else 2
        str.push(((o.key || res[1]) + '[' + res[idx] + ']') + '=' + index + ':' + (if pid then pid[idx] else 'root'))
    )

    if not str.length and o.key
      str.push(o.key + '=')

    return str.join('&')
  
  serializeTree: (element, options) ->
    defaults = 
      attribute: 'id'
      listType: 'ul'
      expression: /(.+)[-=_](.+)/
      key: "tree"
      startDepthCount: 0
      root: false
      
    o = $.extend defaults, options
    sDepth = o.startDepthCount
    ret = []
    left = 1
    
    if o.root
      sDepth += 1
      left += 1
    
    fn_recursiveArray = (item, depth, left) ->
      right = left + 1

      if $(item).children(o.listType).children('li').length > 0
        depth += 1
        
        $(item).children(o.listType).children('li').each(() ->
          right = fn_recursiveArray($(this), depth, right)
        )
        
        depth -= 1

      id = ($(item).attr(o.attribute)).match(o.expression)

      if depth is sDepth
        pid = 'root'
      else
        parentItem = ($(item).parent(o.listType).parent('li').attr(o.attribute)).match(o.expression)
        pid = parentItem[2]

      if id
        ret.push({"item_id": id[2], "parent_id": pid, "depth": depth, "left": left, "right": right})

      left = right + 1
      return left
    
    if o.root
      ret.push(
        "item_id": 'root'
        "parent_id": 'none'
        "depth": sDepth
        "left": '1'
        "right": ($('li', element).length + 1) * 2
      )
    
    $(element).children('li').each(() ->
      left = fn_recursiveArray(this, sDepth, left)
    )

    ret = ret.sort((a,b) -> return (a.left - b.left) )
    
    if o.key
      arr = []
      $.each(ret, () ->
        hash = {}
        param = o.key + "[" + this.item_id + "]"
        hash[param] = this
        arr.push $.param(hash)
      )
      
      return arr.join("&")
    else
      return ret

  insert_fields: (link, method, content) ->
    new_id = new Date().getTime();
    regexp = new RegExp("new_" + method, "g")

    $(link).parents("div.nested_bottom").before(content.replace(regexp, new_id))

  remove_fields: (link) ->
    hidden_field = $(link).prev("input[type=hidden]")
  
    if hidden_field.length isnt 0
      hidden_field.val('1')

    $(link).closest("div.nested_item").hide()

  initSortFields: (dom_id) ->
    container = $(dom_id)

    container.sortable
      cursor: 'move'
      handle: '.nested_input_handle'
      items: '.nested_item'
      opacity: 0.8
      update: (event, ui) => 
        this.updateSortField(event, ui)

    container.disableSelection()

  updateSortField: (event, ui) ->
    element = $(ui.item)
    container = element.parents('div.nested')

    container.find(".nested_item").each (index, item) ->
      $(item).find(".nested_input_sort").val(index)

$(document).ready ->
  window['sunrise'] ?= new Sunrise(window.location.pathname)
  window['sunrise'].setup()
