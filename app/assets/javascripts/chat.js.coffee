$ ->

  client = new WebSocketRails("localhost:3000/websocket")

  client.bind 'message_received', (data) ->
    msg = data.message
    console.log msg

    if msg.length
      $("#chat-window").append "#{msg}<br>"

  $("body").on "submit", "form.chat", (event) ->
    event.preventDefault()
    $input = $(this).find("input")
    client.trigger 'message_sent', { message: $input.val() }
    $input.val(null)
