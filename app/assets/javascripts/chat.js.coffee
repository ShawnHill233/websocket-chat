$ ->

  client = new WebSocketRails("#{window.location.host}/websocket")

  client.bind 'message_received', (data) ->
    msg = data.message

    if msg.length
      $("#chat-window").append "#{msg}<br>"

  $("body").on "submit", "form.chat", (event) ->
    event.preventDefault()
    msg = $(this).find("input")
    client.trigger 'message_sent', { message: msg.val() }
    msg.val(null)
