$ = jQuery

$.fn.extend({
  sort_dialog: (options) ->
    $(this).each((input_field) ->
      new SortDialog(this, options) unless ($ this).hasClass "dialog-init"
    )
})

$.fn.extend({
  import_dialog: (options) ->
    $(this).each((input_field) ->
      new ImportDialog(this, options) unless ($ this).hasClass "dialog-init"
    )
})

class Dialog
  constructor: (@form_field, options = {}) ->
    defaults =
      shadow_field: "#dark-shadow"
      dialog_class: "sunrise-dialog"

    @options = $.extend defaults, options

    this.setup()
    this.register_observers()

  setup: ->
    dom_id = this.generate_random_id()
    @element = $ @form_field

    @shadow = $ @options.shadow_field
    @container = $ '<div/>', { id: dom_id, class: @options.dialog_class }
    @container.hide()
    @shadow.after @container

    @element.addClass "dialog-init"

  register_observers: ->
    @shadow.bind 'click', (evt) => this.hide()
    @element.bind 'click', (evt) =>
      this.show()
      false

  show: ->
    wnd = $(window)
    body = $('body')

    height = if body.innerHeight() > wnd.innerHeight() then body.innerHeight() else wnd.innerHeight()
    @shadow.css 'height', height + 'px'
    @container.css 'left', ($(window).innerWidth() - @container.innerWidth()) / 2 + 'px'

    @shadow.show()
    @container.show()

  hide: ->
    @shadow.hide()
    @container.hide()

  generate_random_id: ->
    string = "dlg_" + this.generate_random_char() + this.generate_random_char() + this.generate_random_char()
    while $("#" + string).length > 0
      string += this.generate_random_char()
    string

  generate_random_char: ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ"
    rand = Math.floor(Math.random() * chars.length)
    newchar = chars.substring rand, rand+1

# SORT
class SortDialog extends Dialog

  setup: ->
    super

    @container.addClass 'sort-wrapper'

    title = $('<div/>', { class: 'sort-title' })
    title.text(@element.attr 'title')

    buttons_holder = $ '<div/>', { class: 'sort-buts-holder' }
    @save_button = $ '<input/>', { type: 'submit', value: @element.data('save_title'), class: 'button', disabled: 'disabled'}
    @cancel_button = $ '<input/>', { type: 'submit', value: @element.data('cancel_title'), class: 'button gray'}

    buttons_holder.append(@save_button).append(@cancel_button)
    title_holder = $ '<div/>', { class: 'sort-title-holder' }
    title_holder.append(title).append(buttons_holder)

    items_container = $ '<div/>', { class: 'sort-items-holder', id: 'sort_items' }

    @container.append(title_holder).append(items_container)

  register_observers: ->
    super

    @cancel_button.bind 'click', (evt) => this.hide()
    @save_button.bind 'click', (evt) => this.save(evt)

  show: ->
    super
    this.load_data()

  save: ->
    items = {}
    klass = this

    $('.sort-item').each (index) ->
      items['ids[' + $(this).data('record-id') + ']'] = index + 1

    $.rails.ajax
      url: @element.data 'url'
      type: 'POST'
      data: items
      success: ->
        klass.hide()

  load_data: ->
    klass = this

    $.ajax
      url: @element.attr 'href'
      success: (data, status, xhr) ->
        $('#sort_items').empty()
        $("#sort-template" ).tmpl(data).appendTo('#sort_items')
        # klass.refresh_counters()

        $("#sort_items").sortable
          cursor: 'crosshair'
          opacity: 0.6
          update: (event, ui) ->
            klass.update_sort_item(event, ui)

  refresh_counters: ->
    $('.sort-item .numb').each (index) ->
      $(this).text index + 1

  update_sort_item: (event, ui) ->
    @save_button.attr 'disabled', false
    this.refresh_counters()

# IMPORT
class ImportDialog extends Dialog
  setup: ->
    super

    @container.addClass 'import-wrapper'

    title = $('<div/>', { class: 'import-title' })
    title.text(@element.data('title'))

    @upload_input = $('<input />', { type: 'file', class: 'import-fileupload' })
    @records_list = $('<ul/>')

    @upload_input.fileupload
      url: @element.data('url')
      dataType: 'json'
      autoUpload: true
      uploadTemplateId: false
      downloadTemplateId: false
      done: (e, data) =>
        $.each data.result.files, (findex, file) =>
          $.each file.records, (rindex, record) =>
            line = $('<li>')

            if record?.html?
              line.append(record.html)
            else
              if record.errors?.length > 0
                rrr = $.extend({}, record)
                delete(rrr.row)
                delete(rrr.errors)
                line.addClass('import-invalid-error')
                line.append($("<b>ROW: #{record.row}</b>"))
                line.append($('<br/>')).append(JSON.stringify(rrr)).append($('<br/>'))
                line.append(record.errors.join('<br/>'))
              else
                line.append($("<b>ROW: #{record.row}</b>"))
                line.append($('<br/>'))
                line.append JSON.stringify(record)

            @records_list.append(line)

        @container.addClass('disabled')
        $("#records").load "#{location.pathname} #records", =>
          @container.removeClass('disabled')

    buttons_holder = $ '<div/>', { class: 'import-buts-holder' }
    @close_button = $ '<input/>', { type: 'reset', value: 'Close', class: 'button gray'}

    buttons_holder.append(@save_button).append(@close_button)
    title_holder = $ '<div/>', { class: 'import-title-holder' }
    title_holder.append(title).append(@upload_input).append(buttons_holder)

    items_container = $ '<div/>', { class: 'import-items-holder', id: 'import_items' }
    items_container.append(@records_list)

    @container.append(title_holder).append(items_container)

  register_observers: ->
    super

    @close_button.bind 'click', (evt) =>
      # this.hide()
      # location?.reload?()
      # @records_list.empty()
      this.hide()
      @records_list.empty()

