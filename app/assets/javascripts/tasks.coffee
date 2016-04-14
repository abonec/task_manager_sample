# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $(document).on 'click', '.change_task_state', (e) ->
    $this = $(this)

    $.ajax(
      url: "/tasks/#{$this.data('id')}",
      data: { task: { state: $this.data('state') } },
      method: 'PUT'
    )
    e.preventDefault()
    false
