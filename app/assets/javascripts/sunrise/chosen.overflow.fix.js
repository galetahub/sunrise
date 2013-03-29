/* 
  Chosen gets "cut" when placed in area with "overflow:hidden".
  https://github.com/harvesthq/chosen/issues/86#issuecomment-11632999 
*/
Chosen.prototype.results_reposition = function() {
  var dd_top, offset, scrolly, toppy;

  dd_top = this.is_multiple ? this.container.height() : this.container.height() - 1;

  // when in a modal get the scroll distance and apply to top of .chzn-drop
  offset = this.container.offset();
  scrolly = parseInt($(window).scrollTop(), 10);
  scrolly = scrolly < 0 ? 0 : scrolly;
  toppy = offset.top+ dd_top - scrolly;

  this.dropdown.css({
    "top": toppy + "px",
    "left": offset.left + "px"
  });
};

Chosen.prototype.results_show = function() {
  var dd_top;
  var self = this;

  // hide .chzn-drop when the window resizes else it will stay fixed with previous top and left coordinates
  $(window).resize(function() {
    self.results_hide();
  });

  if (!this.is_multiple) {
    this.selected_item.addClass("chzn-single-with-drop");
    if (this.result_single_selected) {
      this.result_do_highlight(this.result_single_selected);
    }
  } else if (this.max_selected_options <= this.choices) {
    this.form_field_jq.trigger("liszt:maxselected", {
      chosen: this
    });
    return false;
  }
  dd_top = this.is_multiple ? this.container.height() : this.container.height() - 1;
  this.form_field_jq.trigger("liszt:showing_dropdown", {
    chosen: this
  });

  if($('.post-edit-holder').length) {
    this.results_reposition();

    $(window).scroll(function() {
      if (self.results_showing) {
        self.results_reposition();
      }
    });
  } else {
    this.dropdown.css({
      "top": dd_top + "px",
      "left": 0
    });
  }

  this.results_showing = true;
  this.search_field.focus();
  this.search_field.val(this.search_field.val());
  return this.winnow_results();
};