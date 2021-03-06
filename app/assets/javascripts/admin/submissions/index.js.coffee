$ ->
  return unless $('#admin-submissions').length > 0

  $('.select-all').on 'change', (e) ->
    $('.selected').prop('checked', e.target.checked)

  $('.promote').on 'click', (e) ->
    $(e.target).remove()
    selected = _($('.selected')).map (checkbox) -> if checkbox.checked then $(checkbox).data().id else null
    selected = _(selected).compact()

    $.post('/admin/submissions/make_session', {ids: selected})
