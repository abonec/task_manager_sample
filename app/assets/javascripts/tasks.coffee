# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


update_task = (id, data) ->
  $.ajax(
    url: "/tasks/#{id}",
    data: { task: data },
    method: 'PUT'
  )
$ ->
  $(document).on 'click', '.change_task_state', (e) ->

    update_task($(this).data('id'), state: $(this).data('state'))
    
    e.preventDefault()
    false
  
    
  $(document).on 'click', 'td.user_email', (e) ->
    text = "Список всех id пользователей: \r\n #{JSON.stringify(user_ids)} \r\n Для смены пользователя введите нужный:"
    user_id = prompt(text)
    
    update_task($(this).data('id'), user_id: user_id)
    
    e.preventDefault()
