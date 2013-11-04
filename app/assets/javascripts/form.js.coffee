jQuery ->
  $('#edit_form').on 'click', '.btn-danger', (event) ->
    $(this).closest('fieldset').attr "disabled", "disabled"
    $(this).closest('fieldset').hide()
    event.preventDefault()