window.closeOverlay = ( element=null ) ->
  container         = if element then $( element ).closest('#overlay') else $('#overlay')
  container.hide()
  container.find('#content').html('')

#######################################'#######################################'
## Close Overlay PopUp-Window
#######################################'#######################################'
jQuery ->
  $("#overlay").on 'click', '.button > .close', -> closeOverlay( @ )
  $("#overlay").on 'click', '#background',      -> closeOverlay( @ )
